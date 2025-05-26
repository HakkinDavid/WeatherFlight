//
//  Activity.swift
//  WeatherFlight
//
//  Created by David Emmanuel Santana Romero on 17/05/25.
//
import SwiftUI

struct Activity: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let category: String
    let destination: String
    let recommendedFor: [String] // e.g., ["soleado", "nublado", "lluvia"]
    
    init(id: UUID = UUID(), name: String, description: String, category: String, destination: String, recommendedFor: [String] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.destination = destination
        self.recommendedFor = recommendedFor
    }
}

let sampleActivities = [
    // BERGA (Cataluña, España)
    Activity(name: "Caminata por el malecón", description: "Explora la costa a pie.", category: "Al aire libre", destination: "Berga", recommendedFor: ["soleado", "nublado"]),
    Activity(name: "Museo local", description: "Arte e historia regional.", category: "Cultural", destination: "Berga", recommendedFor: ["lluvia", "nublado"]),
    Activity(name: "Tour gastronómico", description: "Degusta platos típicos.", category: "Gastronomía", destination: "Berga", recommendedFor: ["soleado", "lluvia"]),
    Activity(name: "Senderismo por el Parque Natural del Cadí-Moixeró", description: "Explora rutas montañosas entre abetos, buitres y prados.", category: "Al aire libre", destination: "Berga", recommendedFor: ["soleado", "nublado"]),
    Activity(name: "Recorrido por los bunkers de la Guerra Civil", description: "Conoce la memoria bélica de la región entre trincheras y paisajes.", category: "Histórica", destination: "Berga", recommendedFor: ["nublado"]),
    Activity(name: "Ruta del Patum", description: "Vive o comprende una de las fiestas más intensas de Europa.", category: "Cultural", destination: "Berga", recommendedFor: ["nublado"]),
    Activity(name: "Ciclismo por la Via Verda del Llobregat", description: "Pedalea junto al río y atraviesa túneles ferroviarios rehabilitados.", category: "Aventura", destination: "Berga", recommendedFor: ["soleado"]),
    Activity(name: "Taller de pan con leña", description: "Aprende a hornear pan tradicional catalán en horno de piedra.", category: "Gastronomía", destination: "Berga", recommendedFor: ["lluvia"]),
    Activity(name: "Paseo nocturno por el centro histórico", description: "Luces cálidas, piedra milenaria y aire montañés.", category: "Romántico", destination: "Berga", recommendedFor: ["nublado"]),
    Activity(name: "Meditación en el Santuario de Queralt", description: "Silencio, piedra y cielo para una pausa necesaria.", category: "Espiritual", destination: "Berga", recommendedFor: ["soleado", "nublado"]),

    // SALSIPUEDES (Baja California, México)
    Activity(name: "Excursión en kayak por la bahía", description: "Navega entre formaciones rocosas y agua turquesa.", category: "Aventura", destination: "Salsipuedes", recommendedFor: ["soleado"]),
    Activity(name: "Pesca recreativa", description: "Lanza la caña en un entorno pacífico y poco intervenido.", category: "Al aire libre", destination: "Salsipuedes", recommendedFor: ["soleado"]),
    Activity(name: "Observación de aves marinas", description: "Fotografía pelícanos, cormoranes y gaviotas en su hábitat natural.", category: "Al aire libre", destination: "Salsipuedes", recommendedFor: ["nublado"]),
    Activity(name: "Picnic con vista al acantilado", description: "Un respiro entre olas y desierto.", category: "Relax", destination: "Salsipuedes", recommendedFor: ["soleado"]),
    Activity(name: "Snorkel en aguas tranquilas", description: "Descubre la vida marina del Pacífico norte mexicano.", category: "Aventura", destination: "Salsipuedes", recommendedFor: ["soleado"]),
    Activity(name: "Toma de fotografías del oleaje", description: "Escucha, observa, dispara: arte en estado líquido.", category: "Creatividad", destination: "Salsipuedes", recommendedFor: ["nublado"]),
    Activity(name: "Caminata al amanecer", description: "Siente el aire frío del mar antes de que despierte el mundo.", category: "Al aire libre", destination: "Salsipuedes", recommendedFor: ["soleado"]),
    Activity(name: "Charlas con pescadores locales", description: "Aprende de la sabiduría marinera de generaciones.", category: "Cultural", destination: "Salsipuedes", recommendedFor: ["nublado"]),
    Activity(name: "Lectura solitaria entre rocas", description: "Un refugio para perderse en letras junto al mar.", category: "Relax", destination: "Salsipuedes", recommendedFor: ["soleado", "nublado"]),

    // NACO (Sonora, México)
    Activity(name: "Ruta del ferrocarril", description: "Explora ruinas de estaciones y vías abandonadas.", category: "Histórica", destination: "Naco", recommendedFor: ["nublado"]),
    Activity(name: "Degustación de coyotas", description: "Prueba el dulce tradicional de Sonora hecho por manos locales.", category: "Gastronomía", destination: "Naco", recommendedFor: ["lluvia"]),
    Activity(name: "Cabalgata al atardecer", description: "Paisaje desértico teñido de luz anaranjada.", category: "Al aire libre", destination: "Naco", recommendedFor: ["soleado"]),
    Activity(name: "Visita al Museo de la Frontera", description: "Reflexiona sobre la vida en la línea divisoria con EE.UU.", category: "Cultural", destination: "Naco", recommendedFor: ["lluvia"]),
    Activity(name: "Taller de talabartería", description: "Conoce el arte del cuero en manos sonorenses.", category: "Artesanal", destination: "Naco", recommendedFor: ["nublado"]),
    Activity(name: "Caminata por el cerro El Perico", description: "Panorama de desierto y frontera en un mismo vistazo.", category: "Al aire libre", destination: "Naco", recommendedFor: ["soleado"]),
    Activity(name: "Festival del Burro", description: "Fiesta popular con música, comida y humor.", category: "Cultural", destination: "Naco", recommendedFor: ["soleado"]),
    Activity(name: "Pintura de paisaje desértico", description: "Inmortaliza los tonos del norte en acuarela o pastel.", category: "Creatividad", destination: "Naco", recommendedFor: ["nublado"]),

    // XBOX (Yucatán, México)
    Activity(name: "Toma de selfies con el letrero ‘Xbox’", description: "El pueblo con nombre de consola: un fenómeno en sí mismo.", category: "Curioso", destination: "Xbox", recommendedFor: ["soleado", "nublado"]),
    Activity(name: "Charlas comunitarias sobre el origen del nombre", description: "Escucha historias reales y mitos que rodean el nombre.", category: "Cultural", destination: "Xbox", recommendedFor: ["lluvia"]),
    Activity(name: "Torneo de videojuegos local", description: "Competencia entre generaciones en un contexto rural inédito.", category: "Social", destination: "Xbox", recommendedFor: ["lluvia", "nublado"]),
    Activity(name: "Taller de bordado maya", description: "Rescate de tradiciones que conviven con la modernidad nominal.", category: "Artesanal", destination: "Xbox", recommendedFor: ["lluvia"]),
    Activity(name: "Comida yucateca casera", description: "Panuchos, salbutes, relleno negro y buen humor local.", category: "Gastronomía", destination: "Xbox", recommendedFor: ["soleado", "lluvia"]),
    Activity(name: "Tour fotográfico de ironía rural", description: "Imágenes donde se cruzan dos mundos: el maya y el digital.", category: "Creatividad", destination: "Xbox", recommendedFor: ["soleado"]),
    Activity(name: "Cine al aire libre con películas de acción", description: "Ríe viendo Rápido y Furioso en el pueblo de Xbox.", category: "Social", destination: "Xbox", recommendedFor: ["nublado"]),
    Activity(name: "Caminata por caminos de piedra blanca", description: "Naturaleza, sol y aire que huele a milpa y pasto recién cortado.", category: "Al aire libre", destination: "Xbox", recommendedFor: ["soleado"]),

    // VÁLGAME DIOS (Sinaloa, México)
    Activity(name: "Ruta del nombre: ¿por qué se llama así?", description: "Historias de accidentes, milagros y sustos fundacionales.", category: "Cultural", destination: "Válgame Dios", recommendedFor: ["nublado", "lluvia"]),
    Activity(name: "Visita a la capilla del pueblo", description: "Religiosidad rural y arquitectura sin artificios.", category: "Espiritual", destination: "Válgame Dios", recommendedFor: ["soleado", "nublado"]),
    Activity(name: "Comida de rancho sinaloense", description: "Machaca, chilorio y frijoles puercos servidos con tortillas recién hechas.", category: "Gastronomía", destination: "Válgame Dios", recommendedFor: ["soleado", "lluvia"]),
    Activity(name: "Taller de corridos tradicionales", description: "Composición oral como testimonio de la vida cotidiana y sus excesos.", category: "Cultural", destination: "Válgame Dios", recommendedFor: ["lluvia"]),
    Activity(name: "Festival de la exclamación", description: "Eventos lúdicos y teatrales inspirados en el nombre del pueblo.", category: "Creatividad", destination: "Válgame Dios", recommendedFor: ["nublado"]),
    Activity(name: "Caminata por veredas rurales", description: "Monte bajo, insectos cantores y horizonte sin interrupciones.", category: "Al aire libre", destination: "Válgame Dios", recommendedFor: ["soleado"]),
    Activity(name: "Tarde de leyendas populares", description: "Historias de aparecidos, tesoros enterrados y santos fugitivos.", category: "Cultural", destination: "Válgame Dios", recommendedFor: ["nublado"]),
    Activity(name: "Observación astronómica rural", description: "Cielo profundo y estrellado como en los tiempos antiguos.", category: "Al aire libre", destination: "Válgame Dios", recommendedFor: ["soleado", "nublado"])
]
