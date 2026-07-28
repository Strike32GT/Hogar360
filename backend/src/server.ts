import { env } from './config/env';
import { createApp } from './app';
import { closeDatabase, connectDatabase } from './config/database';
import { ensureAuthIndexes } from './modules/auth/auth.service';

const startServer = async (): Promise<void> => {
  await connectDatabase();
  await ensureAuthIndexes();

  const app = createApp();
  const server = app.listen(env.port, () => {
    console.log(`Hogar360 API running on port ${env.port}`);
  });

  const shutdown = async (): Promise<void> => {
    server.close(async () => {
      await closeDatabase();
      process.exit(0);
    });
  };

  process.on('SIGINT', () => {
    void shutdown();
  });

  process.on('SIGTERM', () => {
    void shutdown();
  });
};

startServer().catch((error: unknown) => {
  console.error('Failed to start Hogar360 API', error);
  process.exit(1);
});
