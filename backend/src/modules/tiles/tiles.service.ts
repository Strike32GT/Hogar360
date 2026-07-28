import type { ObjectId } from 'mongodb';

import { getDatabase } from '../../config/database';
import { HttpError } from '../../utils/http-error';
import type {
  TileCalculationHistoryDocument,
  TileCalculationHistoryResponse,
  TileCalculationInput,
  TileCalculationResult,
  TileSummaryResponse,
} from './tile-calculation.model';

const tileCalculationsCollectionName = 'tileCalculations';

const isPositiveNumber = (value: unknown): value is number => {
  return typeof value === 'number' && Number.isFinite(value) && value > 0;
};

export const calculateTiles = (
  input: TileCalculationInput,
): TileCalculationResult => {
  if (
    !isPositiveNumber(input.floorLength) ||
    !isPositiveNumber(input.floorWidth) ||
    !isPositiveNumber(input.tileLength) ||
    !isPositiveNumber(input.tileWidth) ||
    !Number.isInteger(input.tilesPerBox) ||
    input.tilesPerBox <= 0 ||
    typeof input.wastePercentage !== 'number' ||
    input.wastePercentage < 0
  ) {
    throw new HttpError({
      statusCode: 400,
      code: 'INVALID_TILE_CALCULATION_INPUT',
      message: 'All measurements must be valid positive numbers',
    });
  }

  const floorArea = input.floorLength * input.floorWidth;
  const tileArea = (input.tileLength / 100) * (input.tileWidth / 100);
  const baseTiles = Math.ceil(floorArea / tileArea);
  const wasteTiles = Math.ceil(baseTiles * (input.wastePercentage / 100));
  const totalTiles = baseTiles + wasteTiles;
  const boxes = Math.ceil(totalTiles / input.tilesPerBox);

  return {
    floorArea,
    tileArea,
    baseTiles,
    wasteTiles,
    totalTiles,
    boxes,
  };
};

export const saveTileCalculation = async ({
  input,
  userId,
}: {
  readonly input: TileCalculationInput;
  readonly userId: ObjectId;
}): Promise<TileCalculationHistoryResponse> => {
  const result = calculateTiles(input);
  const createdAt = new Date();
  const document: TileCalculationHistoryDocument = {
    ...input,
    ...result,
    userId,
    createdAt,
  };

  const insertResult = await getDatabase()
    .collection<TileCalculationHistoryDocument>(tileCalculationsCollectionName)
    .insertOne(document);

  return {
    id: String(insertResult.insertedId),
    ...input,
    ...result,
    createdAt,
  };
};

export const listTileCalculations = async (
  userId: ObjectId,
): Promise<readonly TileCalculationHistoryResponse[]> => {
  const documents = await getDatabase()
    .collection<TileCalculationHistoryDocument>(tileCalculationsCollectionName)
    .find({ userId })
    .sort({ createdAt: -1 })
    .limit(50)
    .toArray();

  return documents.map((document) => ({
    id: String(document._id),
    floorLength: document.floorLength,
    floorWidth: document.floorWidth,
    tileLength: document.tileLength,
    tileWidth: document.tileWidth,
    tilesPerBox: document.tilesPerBox,
    wastePercentage: document.wastePercentage,
    floorArea: document.floorArea,
    tileArea: document.tileArea,
    baseTiles: document.baseTiles,
    wasteTiles: document.wasteTiles,
    totalTiles: document.totalTiles,
    boxes: document.boxes,
    createdAt: document.createdAt,
  }));
};

export const getTileSummary = async (
  userId: ObjectId,
): Promise<TileSummaryResponse> => {
  const calculationsCount = await getDatabase()
    .collection<TileCalculationHistoryDocument>(tileCalculationsCollectionName)
    .countDocuments({ userId });

  return {
    calculationsCount,
    completionPercentage:
      calculationsCount === 0 ? 0 : Math.min(100, 80 + calculationsCount * 5),
  };
};
