import type { Request, Response } from 'express';

import { HttpError } from '../../utils/http-error';
import {
  calculateTiles,
  getTileSummary,
  listTileCalculations,
  saveTileCalculation,
} from './tiles.service';

export const calculate = async (req: Request, res: Response): Promise<void> => {
  const result = calculateTiles(req.body);
  res.status(200).json(result);
};

const getAuthenticatedUserId = (req: Request) => {
  if (!req.user) {
    throw new HttpError({
      statusCode: 401,
      code: 'UNAUTHORIZED',
      message: 'Authorization token is required',
    });
  }

  return req.user.objectId;
};

export const saveHistory = async (req: Request, res: Response): Promise<void> => {
  const calculation = await saveTileCalculation({
    input: req.body,
    userId: getAuthenticatedUserId(req),
  });
  res.status(201).json(calculation);
};

export const getHistory = async (req: Request, res: Response): Promise<void> => {
  const history = await listTileCalculations(getAuthenticatedUserId(req));
  res.status(200).json(history);
};

export const getSummary = async (req: Request, res: Response): Promise<void> => {
  const summary = await getTileSummary(getAuthenticatedUserId(req));
  res.status(200).json(summary);
};
