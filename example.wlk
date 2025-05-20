//------------RODADOS------------
import wollok.game.*

class Corsa {
  var property color
  var position = new Position(x=0, y=0) //game.at(0, 0)
  method capacidad() = 4
  method velocidadMaxima() = 150
  method peso() = 1300
}

class Kwid {
  var property tieneTanqueAdicional 
  method capacidad() = if(tieneTanqueAdicional) 3 else 4
  method velocidadMaxima() = if(tieneTanqueAdicional) 110 else 120
  method peso() = 1200 + if(tieneTanqueAdicional) 150 else 0
  method color() = "azul"
}

object trafic {
  var property interior = comodo
  var property motor = pulenta
  method capacidad() = interior.capacidad()
  method velocidadMaxima() = motor.velocidadMaxima()
  method peso() = 4000 + interior.peso() + motor.peso()
  method color() = "blanco"
}

class AutoEspecial {
  var property color
  var property capacidad
  var property velocidadMaxima
  var property peso
}



//------------MODIFICACIONES DEL INTERIOR DE LA TRAFIC------------
object comodo {
  method capacidad() = 5
  method peso() = 700
}

object popular {
  method capacidad() = 12
  method peso() = 1000
}

object pulenta {
  method velocidadMaxima() = 130
  method peso() = 800
}

object bataton {
  method velocidadMaxima() = 80
  method peso() = 500
}


//------------DEPENDENCIA------------
class Dependencia {
  const flota = []
  var property empleados = 0

  method agregartAFlota(rodado) {flota.add(rodado)}
  method quitarDeFlota(rodado) {flota.remove(rodado)}

  method pesoTotalFlota() = flota.sum({r => r.peso()})

  method estaBienEquipada() = self.tieneAlMenosRodados(3) and self.losRodadosAlcanzanLosCien()
  method tieneAlMenosRodados(cantidad) = flota.size() >= cantidad
  method losRodadosAlcanzanLosCien() = flota.all({r => r.velocidadMaxima() >= 100})

  method capacidadTotalEnColor(color) = self.rodadosDeColor(color).sum({r => r.capacidad()})
  method rodadosDeColor(color) = flota.filter({r => r.color() == color})

  method colorDelRodadoMasRapido() = flota.max({r => r.velocidadMaxima()}).color()

  method capacidadFaltante() = (empleados - self.capacidadTotalFlota()).max(0)
  method capacidadTotalFlota() = flota.sum({r => r.capacidad()})

  method esGrande() = self.tieneAlMenosRodados(5) and empleados >= 40
}
