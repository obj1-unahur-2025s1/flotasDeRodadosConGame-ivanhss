  //------------RODADOS------------
import wollok.game.*

class Corsa {
  var property color
  method initialize(){
    if(not coloresValidos.listaDeColores().contains(color)){
      self.error(color.toString() + " " + "no es un color valido para un auto")
    }
  }
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
  method initialize(){
    if(not coloresValidos.listaDeColores().contains(color)){
      self.error(color.toString() + " " + "no es un color valido para un auto")
    }
  }
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
  const property flota = []
  const property pedidos = #{}
  var property empleados = 0

  method agregarAFlota(rodado) {flota.add(rodado)}
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

  //Registro de pedidos
  method agregarAPedidos(pedido) {pedidos.add(pedido)}
  method quitarDePedidos(pedido) {pedidos.remove(pedido)}

  method totalDePasajerosPedidos()= pedidos.sum({p => p.cantidadDePasajeros()})

  method pedidosNoSatisfactorios() = pedidos.filter({p => !p.esSatisfactorio()})

  method colorIncompatible(unColor)= pedidos.all({p => p.coloresIncompatibles().contains(unColor)})

  method queTodosRelajen(){pedidos.forEach({p => p.relajar()})}
}


//------------COLORES------------
object coloresValidos {
  const property listaDeColores = #{"rojo","verde","azul","blanco"}
}


//------------PEDIDOS------------
class Pedido {
  const property coloresIncompatibles = #{}
  var property distancia //distancia a recorrer en kilometros
  var tiempoMaximo //tiempo maximo en el que se debe hacer el viaje
  var property cantidadDePasajeros //cantidad de pasajeros a transportar
  var property rodado

  method agregarColorIncompatible(unColor){coloresIncompatibles.add(unColor)}
  method eliminarColorIncompatible(unColor){
    if(!coloresIncompatibles.contains(unColor)){
      self.error("El color " + unColor + " "+"no estaba incluido en la lista de colores incompatibles")
    }
    coloresIncompatibles.remove(unColor)
  }
  method initialize(){
    if(distancia <= 0){
      self.error("el valor: "+ distancia.toString()+" " + "no es un entero positivo")
    }
    if(tiempoMaximo <= 0){
      self.error("el valor: "+ tiempoMaximo.toString()+" " + "no es un entero positivo")
    }
    if(cantidadDePasajeros <= 0){
      self.error("el valor: "+ cantidadDePasajeros.toString()+" " + "no es un entero positivo")
    }
  }
  method velocidadRequerida()= distancia / tiempoMaximo
  method esSatisfactorio(){
    return
      rodado.velocidadMaxima() >= self.velocidadRequerida() + 10 and
      rodado.capacidad() >= self.cantidadDePasajeros() and
      ! self.coloresIncompatibles().contains(rodado.color())
  }
  method acelerar(){tiempoMaximo = 1.max(tiempoMaximo - 1)}
  method relajar(){tiempoMaximo += 1}
}
