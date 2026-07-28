import { MongoClient, type Db } from 'mongodb';

import { env } from './env';

let client: MongoClient | null = null;
let database: Db | null = null;

/** Opens a reusable MongoDB connection for the API process. */
export const connectDatabase = async (): Promise<void> => {
  if (database) return;

  client = new MongoClient(env.mongoUri, {
    maxPoolSize: 20,
    minPoolSize: env.nodeEnv === 'production' ? 2 : 0,
    serverSelectionTimeoutMS: 5000,
  });
  await client.connect();
  database = client.db(env.mongoDbName);

  console.log(`MongoDB connected to database "${env.mongoDbName}"`);
};

/** Returns the active MongoDB database instance. */
export const getDatabase = (): Db => {
  if (!database) {
    throw new Error('Database has not been connected yet');
  }

  return database;
};

/** Closes the MongoDB connection. */
export const closeDatabase = async (): Promise<void> => {
  await client?.close();
  client = null;
  database = null;
};
