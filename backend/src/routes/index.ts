import { Router } from 'express';

import authRoutes from '../modules/auth/auth.routes';
import paintRoutes from '../modules/paint/paint.routes';
import tilesRoutes from '../modules/tiles/tiles.routes';

const router = Router();

router.use('/auth', authRoutes);
router.use('/tiles', tilesRoutes);
router.use('/paint', paintRoutes);

export default router;
