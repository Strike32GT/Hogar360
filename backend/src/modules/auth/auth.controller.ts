import type { Request, Response } from 'express';

import { HttpError } from '../../utils/http-error';
import { loginUser, registerUser, updateUser } from './auth.service';

export const register = async (req: Request, res: Response): Promise<void> => {
  const session = await registerUser(req.body);
  res.status(201).json(session);
};

export const login = async (req: Request, res: Response): Promise<void> => {
  const session = await loginUser(req.body);
  res.status(200).json(session);
};

export const getCurrentUser = async (_req: Request, res: Response): Promise<void> => {
  res.status(200).json(_req.user);
};

export const updateCurrentUser = async (req: Request, res: Response): Promise<void> => {
  if (!req.user) {
    throw new HttpError({
      statusCode: 401,
      code: 'UNAUTHORIZED',
      message: 'Authorization token is required',
    });
  }

  const user = await updateUser(req.user.objectId, req.body);
  res.status(200).json(user);
};
