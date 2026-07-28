import { Router } from 'express';

import { authMiddleware } from '../../middlewares/auth.middleware';
import { asyncHandler } from '../../utils/async-handler';
import { getCurrentUser, login, register, updateCurrentUser } from './auth.controller';

const router = Router();

router.post('/register', asyncHandler(register));
router.post('/login', asyncHandler(login));
router.get('/me', authMiddleware, asyncHandler(getCurrentUser));
router.patch('/me', authMiddleware, asyncHandler(updateCurrentUser));

export default router;
