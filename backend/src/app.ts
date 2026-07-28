import express, { type Express, type Request, type Response } from 'express';

import { errorMiddleware } from './middlewares/error.middleware';
import { requestLoggerMiddleware } from './middlewares/request-logger.middleware';
import apiRoutes from './routes';
import { HttpError } from './utils/http-error';

/** Creates the Express application with global middleware and API routes. */
export const createApp = (): Express => {
  const app = express();

  app.use((_req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, PATCH, DELETE, OPTIONS');
    next();
  });
  app.options(/.*/, (_req, res) => {
    res.sendStatus(204);
  });

  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  app.use(requestLoggerMiddleware);

  app.get('/health', (_req: Request, res: Response) => {
    res.status(200).json({ status: 'ok', service: 'hogar360-backend' });
  });

  app.use('/api', apiRoutes);

  app.use((_req: Request, _res: Response) => {
    throw new HttpError({
      statusCode: 404,
      code: 'ROUTE_NOT_FOUND',
      message: 'Route not found',
    });
  });

  app.use(errorMiddleware);

  return app;
};
