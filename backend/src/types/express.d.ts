import type { ObjectId } from 'mongodb';

declare global {
  namespace Express {
    interface Request {
      user?: {
        readonly id: string;
        readonly name: string;
        readonly email: string;
        readonly objectId: ObjectId;
      };
    }
  }
}

export {};
