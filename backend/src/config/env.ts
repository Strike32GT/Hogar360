import 'dotenv/config';

interface EnvConfig {
  readonly port: number;
  readonly nodeEnv: string;
  readonly mongoUri: string;
  readonly mongoDbName: string;
}

const parsePort = (value: string | undefined): number => {
  const port = Number(value ?? 3000);
  return Number.isInteger(port) && port > 0 ? port : 3000;
};

export const env: EnvConfig = {
  port: parsePort(process.env.PORT),
  nodeEnv: process.env.NODE_ENV ?? 'development',
  mongoUri: process.env.MONGODB_URI ?? 'mongodb://localhost:27017/hogar360',
  mongoDbName: process.env.MONGODB_DB_NAME ?? 'hogar360',
};
