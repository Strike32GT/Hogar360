import { Router } from 'express';

import { asyncHandler } from '../../utils/async-handler';
import { getColorById, listColors } from './paint.controller';

const router = Router();

router.get('/colors', asyncHandler(listColors));
router.get('/colors/:id', asyncHandler(getColorById));

export default router;
