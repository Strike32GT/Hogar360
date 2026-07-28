import type { ObjectId } from 'mongodb';

export interface User {
  readonly id: string;
  readonly name: string;
  readonly email: string;
  readonly passwordHash: string;
  readonly passwordSalt: string;
  readonly createdAt: Date;
  readonly updatedAt: Date;
}

export interface UserDocument {
  readonly _id: ObjectId;
  readonly name: string;
  readonly email: string;
  readonly passwordHash: string;
  readonly passwordSalt: string;
  readonly createdAt: Date;
  readonly updatedAt: Date;
}

export interface AuthUserResponse {
  readonly id: string;
  readonly name: string;
  readonly email: string;
}

export interface RegisterUserInput {
  readonly name: string;
  readonly email: string;
  readonly password: string;
}

export interface LoginUserInput {
  readonly email: string;
  readonly password: string;
}

export interface UpdateUserInput {
  readonly name?: string;
}

export interface SessionDocument {
  readonly _id?: ObjectId;
  readonly token: string;
  readonly userId: ObjectId;
  readonly createdAt: Date;
}
