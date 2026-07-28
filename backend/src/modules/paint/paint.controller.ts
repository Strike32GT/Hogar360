import type { Request, Response } from 'express';

import { getPaintColorById, listPaintColors } from './paint.service';

export const listColors = async (_req: Request, res: Response): Promise<void> => {
  res.status(200).json(listPaintColors());
};

export const getColorById = async (req: Request, res: Response): Promise<void> => {
  const id = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;
  res.status(200).json(getPaintColorById(id));
};
