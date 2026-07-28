import { Router } from 'express';

import { authMiddleware } from '../../middlewares/auth.middleware';
import { asyncHandler } from '../../utils/async-handler';
import { calculate, getHistory, getSummary, saveHistory } from './tiles.controller';

const router = Router();

router.post('/calculate', asyncHandler(calculate));
router.get('/summary', authMiddleware, asyncHandler(getSummary));
router.get('/history', authMiddleware, asyncHandler(getHistory));
router.post('/history', authMiddleware, asyncHandler(saveHistory));

export default router;
