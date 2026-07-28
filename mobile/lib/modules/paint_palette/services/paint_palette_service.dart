import '../models/paint_color.dart';

class PaintPaletteService {
  List<PaintColor> getColors() {
    return const [
      PaintColor(
        name: 'Azul Profundo',
        hex: '#005F98',
        family: 'Azules',
        recommendation: 'Ideal para dormitorios o zonas de concentración.',
      ),
      PaintColor(
        name: 'Tierra Quemada',
        hex: '#914D00',
        family: 'Cálidos',
        recommendation: 'Funciona bien en salas con madera y luz cálida.',
      ),
      PaintColor(
        name: 'Cielo Despejado',
        hex: '#2378B8',
        family: 'Azules',
        recommendation: 'Da una sensación fresca en espacios pequeños.',
      ),
      PaintColor(
        name: 'Naranja Atardecer',
        hex: '#FC9024',
        family: 'Cálidos',
        recommendation: 'Perfecto para acentos, columnas o una pared focal.',
      ),
      PaintColor(
        name: 'Gris Urbano',
        hex: '#E3E2E1',
        family: 'Neutros',
        recommendation: 'Buena base para combinar con muebles coloridos.',
      ),
      PaintColor(
        name: 'Negro Carbón',
        hex: '#1A1C1C',
        family: 'Neutros',
        recommendation: 'Úsalo en detalles para dar contraste moderno.',
      ),
      PaintColor(
        name: 'Azul Glaciar',
        hex: '#99CBFF',
        family: 'Azules',
        recommendation: 'Recomendado para habitaciones luminosas.',
      ),
      PaintColor(
        name: 'Melocotón Suave',
        hex: '#FFB77E',
        family: 'Cálidos',
        recommendation: 'Aporta calidez sin saturar el ambiente.',
      ),
      PaintColor(
        name: 'Verde Musgo Suave',
        hex: '#81B29A',
        family: 'Verdes',
        recommendation: 'Ideal para salas luminosas y ambientes tranquilos.',
      ),
    ];
  }
}
