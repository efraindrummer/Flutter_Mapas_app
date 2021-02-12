part of 'custom_markers.dart';

class MarkerDestinoPainter extends CustomPainter {

  final String descripcion;
  final double metros;

  MarkerDestinoPainter(this.descripcion, this.metros);
  
  @override
  void paint(Canvas canvas, Size size) {
    final double circuloNegroR = 20;
    final double circuloBlancoR = 7;

    Paint paint = new Paint()..color =  Colors.black;

    //dibujar un circulo negro
    canvas.drawCircle(
      Offset(circuloNegroR , size.height - circuloNegroR), 
      20,
      paint)
    ;

    //Circulo blanco
    paint.color = Colors.white;

    canvas.drawCircle(
      Offset(circuloNegroR, size.height - circuloNegroR), 
      circuloBlancoR, 
      paint
    );

    //sombra
    final Path path = new Path();
    path.moveTo(0, 0);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(0, 100);

    canvas.drawShadow(path, Colors.black87, 10, false);
    
    //caja blanca
    final cajaBlanca = Rect.fromLTWH(0, 20, size.width - 10, 80);
    canvas.drawRect(cajaBlanca, paint);

    //caja negra
    paint.color = Colors.black;
    final cajaNegra = Rect.fromLTWH(0, 20, 70, 80);
    canvas.drawRect(cajaNegra, paint);

    //dibujar textos
    double kilometros = this.metros / 1000;
    kilometros = (kilometros * 100).floor().toDouble();
    kilometros = kilometros / 100;

    TextSpan textSpan = new TextSpan(
      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
      text: '$kilometros'
    );

    TextPainter textPainter = new TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center
    )..layout(
      maxWidth: 70,
      minWidth: 70
    );

    textPainter.paint(canvas, Offset(0, 35));

    //dibujar minutos
    textSpan = new TextSpan(
      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
      text: 'Km'
    );

    textPainter = new TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center
    )..layout(
      maxWidth: 70,
    );

    textPainter.paint(canvas, Offset(20, 67));

    //ubicacion
    textSpan = new TextSpan(
      style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
      text: this.descripcion
    );

    textPainter = new TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines: 2,
      ellipsis: '...'
    )..layout(
      maxWidth: size.width - 100,
    );

    textPainter.paint(canvas, Offset(90, 35));
  }

  @override
  bool shouldRepaint(MarkerDestinoPainter oldDelegate) => true;
}