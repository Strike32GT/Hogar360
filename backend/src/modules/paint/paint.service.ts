import { HttpError } from '../../utils/http-error';
import type { PaintColor } from './paint-color.model';

const paintColors: readonly PaintColor[] = [
  {
    id: 'azul-profundo',
    name: 'Azul Profundo',
    hex: '#005F98',
    family: 'Azules',
    recommendation: 'Ideal para dormitorios o zonas de concentración.',
    isActive: true,
  },
  {
    id: 'naranja-atardecer',
    name: 'Naranja Atardecer',
    hex: '#FC9024',
    family: 'Cálidos',
    recommendation: 'Perfecto para acentos, columnas o una pared focal.',
    isActive: true,
  },
  {
    id: 'verde-musgo-suave',
    name: 'Verde Musgo Suave',
    hex: '#81B29A',
    family: 'Verdes',
    recommendation: 'Ideal para salas luminosas y ambientes tranquilos.',
    isActive: true,
  },
];

export const listPaintColors = (): readonly PaintColor[] => {
  return paintColors.filter((color) => color.isActive);
};

export const getPaintColorById = (id: string): PaintColor => {
  const color = paintColors.find((item) => item.id === id && item.isActive);

  if (!color) {
    throw new HttpError({
      statusCode: 404,
      code: 'PAINT_COLOR_NOT_FOUND',
      message: 'Paint color not found',
    });
  }

  return color;
};
