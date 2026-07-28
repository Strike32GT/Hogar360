import { randomBytes, scrypt as scryptCallback, timingSafeEqual } from 'node:crypto';
import { promisify } from 'node:util';

import { getDatabase } from '../../config/database';
import { HttpError } from '../../utils/http-error';
import type {
  AuthUserResponse,
  LoginUserInput,
  RegisterUserInput,
  SessionDocument,
  UpdateUserInput,
  UserDocument,
} from './user.model';

const scrypt = promisify(scryptCallback);
const usersCollectionName = 'users';
const sessionsCollectionName = 'sessions';

export const ensureAuthIndexes = async (): Promise<void> => {
  await getDatabase()
    .collection<UserDocument>(usersCollectionName)
    .createIndex({ email: 1 }, { unique: true });
  await getDatabase()
    .collection<SessionDocument>(sessionsCollectionName)
    .createIndex({ token: 1 }, { unique: true });
};

export interface AuthSession {
  readonly token: string;
  readonly user: AuthUserResponse;
}

const normalizeEmail = (email: string): string => email.trim().toLowerCase();

const hashPassword = async (
  password: string,
  salt: string,
): Promise<string> => {
  const derivedKey = (await scrypt(password, salt, 64)) as Buffer;
  return derivedKey.toString('hex');
};

const verifyPassword = async ({
  password,
  passwordHash,
  passwordSalt,
}: {
  readonly password: string;
  readonly passwordHash: string;
  readonly passwordSalt: string;
}): Promise<boolean> => {
  const incomingHash = await hashPassword(password, passwordSalt);
  return timingSafeEqual(Buffer.from(incomingHash, 'hex'), Buffer.from(passwordHash, 'hex'));
};

const toAuthUserResponse = (user: UserDocument): AuthUserResponse => ({
  id: String(user._id),
  name: user.name,
  email: user.email,
});

const createSessionToken = (): string => randomBytes(32).toString('hex');

const createSession = async (userId: UserDocument['_id']): Promise<string> => {
  const token = createSessionToken();
  await getDatabase().collection<SessionDocument>(sessionsCollectionName).insertOne({
    token,
    userId,
    createdAt: new Date(),
  });
  return token;
};

export const getUserByToken = async (
  token: string,
): Promise<AuthUserResponse & { readonly objectId: UserDocument['_id'] }> => {
  const session = await getDatabase()
    .collection<SessionDocument>(sessionsCollectionName)
    .findOne({ token });

  if (!session) {
    throw new HttpError({
      statusCode: 401,
      code: 'INVALID_TOKEN',
      message: 'Invalid authorization token',
    });
  }

  const user = await getDatabase()
    .collection<UserDocument>(usersCollectionName)
    .findOne({ _id: session.userId });

  if (!user) {
    throw new HttpError({
      statusCode: 401,
      code: 'USER_NOT_FOUND',
      message: 'User session is no longer valid',
    });
  }

  return {
    ...toAuthUserResponse(user),
    objectId: user._id,
  };
};

export const registerUser = async (
  input: RegisterUserInput,
): Promise<AuthSession> => {
  if (!input.name?.trim() || !input.email?.trim() || !input.password) {
    throw new HttpError({
      statusCode: 400,
      code: 'INVALID_REGISTER_INPUT',
      message: 'Name, email and password are required',
    });
  }

  if (input.password.length < 6) {
    throw new HttpError({
      statusCode: 400,
      code: 'WEAK_PASSWORD',
      message: 'Password must have at least 6 characters',
    });
  }

  const email = normalizeEmail(input.email);
  const users = getDatabase().collection<UserDocument>(usersCollectionName);
  const existingUser = await users.findOne({ email });

  if (existingUser) {
    throw new HttpError({
      statusCode: 409,
      code: 'EMAIL_ALREADY_REGISTERED',
      message: 'Email is already registered',
    });
  }

  const passwordSalt = randomBytes(16).toString('hex');
  const passwordHash = await hashPassword(input.password, passwordSalt);
  const now = new Date();

  const insertResult = await users.insertOne({
    name: input.name.trim(),
    email,
    passwordHash,
    passwordSalt,
    createdAt: now,
    updatedAt: now,
  } as UserDocument);

  const user: UserDocument = {
    _id: insertResult.insertedId,
    name: input.name.trim(),
    email,
    passwordHash,
    passwordSalt,
    createdAt: now,
    updatedAt: now,
  };

  return {
    token: await createSession(user._id),
    user: toAuthUserResponse(user),
  };
};

export const loginUser = async (input: LoginUserInput): Promise<AuthSession> => {
  const email = normalizeEmail(input.email ?? '');
  const users = getDatabase().collection<UserDocument>(usersCollectionName);
  const user = await users.findOne({ email });

  if (!user) {
    throw new HttpError({
      statusCode: 401,
      code: 'INVALID_CREDENTIALS',
      message: 'Invalid email or password',
    });
  }

  const isValidPassword = await verifyPassword({
    password: input.password ?? '',
    passwordHash: user.passwordHash,
    passwordSalt: user.passwordSalt,
  });

  if (!isValidPassword) {
    throw new HttpError({
      statusCode: 401,
      code: 'INVALID_CREDENTIALS',
      message: 'Invalid email or password',
    });
  }

  return {
    token: await createSession(user._id),
    user: toAuthUserResponse(user),
  };
};

export const updateUser = async (
  userId: UserDocument['_id'],
  input: UpdateUserInput,
): Promise<AuthUserResponse> => {
  const name = input.name?.trim();

  if (!name) {
    throw new HttpError({
      statusCode: 400,
      code: 'INVALID_PROFILE_INPUT',
      message: 'Name is required',
    });
  }

  const users = getDatabase().collection<UserDocument>(usersCollectionName);
  const result = await users.findOneAndUpdate(
    { _id: userId },
    { $set: { name, updatedAt: new Date() } },
    { returnDocument: 'after' },
  );

  if (!result) {
    throw new HttpError({
      statusCode: 404,
      code: 'USER_NOT_FOUND',
      message: 'User was not found',
    });
  }

  return toAuthUserResponse(result);
};
