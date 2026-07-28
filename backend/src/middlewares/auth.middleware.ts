import type { NextFunction, Request, Response } from 'express';

import { getUserByToken } from '../modules/auth/auth.service';

export const authMiddleware = async (
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> => {
  const authorization = req.headers.authorization;

  if (!authorization?.startsWith('Bearer ')) {
    res.status(401).json({
      error: 'UNAUTHORIZED',
      message: 'Authorization token is required',
    });
    return;
  }

  try {
    const token = authorization.slice('Bearer '.length);
    const user = await getUserByToken(token);
    req.user = {
      id: user.id,
      name: user.name,
      email: user.email,
      objectId: user.objectId,
    };
    next();
  } catch (error) {
    next(error);
  }
};
