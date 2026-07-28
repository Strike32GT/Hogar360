interface HttpErrorParams {
  readonly statusCode: number;
  readonly code: string;
  readonly message: string;
}

export class HttpError extends Error {
  readonly statusCode: number;
  readonly code: string;

  constructor({ statusCode, code, message }: HttpErrorParams) {
    super(message);
    this.name = 'HttpError';
    this.statusCode = statusCode;
    this.code = code;
  }
}
