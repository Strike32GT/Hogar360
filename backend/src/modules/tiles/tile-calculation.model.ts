import type { ObjectId } from 'mongodb';

export interface TileCalculationInput {
  readonly floorLength: number;
  readonly floorWidth: number;
  readonly tileLength: number;
  readonly tileWidth: number;
  readonly tilesPerBox: number;
  readonly wastePercentage: number;
}

export interface TileCalculationResult {
  readonly floorArea: number;
  readonly tileArea: number;
  readonly baseTiles: number;
  readonly wasteTiles: number;
  readonly totalTiles: number;
  readonly boxes: number;
}

export interface TileCalculationHistoryDocument extends TileCalculationInput, TileCalculationResult {
  readonly _id?: ObjectId;
  readonly userId: ObjectId;
  readonly createdAt: Date;
}

export interface TileCalculationHistoryResponse extends TileCalculationResult {
  readonly id: string;
  readonly floorLength: number;
  readonly floorWidth: number;
  readonly tileLength: number;
  readonly tileWidth: number;
  readonly tilesPerBox: number;
  readonly wastePercentage: number;
  readonly createdAt: Date;
}

export interface TileSummaryResponse {
  readonly calculationsCount: number;
  readonly completionPercentage: number;
}
