//! Core orbital mechanics and physics for Rendezvous

use std::f64::consts::PI;
use serde::{Serialize, Deserialize};
use serde_json;
use std::fs::File;
use std::io::{Write, Read};
use std::path::Path;

/// Calculated orbital transfer data
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TransferInfo {
    /// Radius of initial orbit (meters)
    pub orbit_radius1: f64,
    /// Radius of target orbit (meters)
    pub orbit_radius2: f64,
    /// ΔV required for first burn (m/s)
    pub delta_v1: f64,
    /// ΔV required for second burn (m/s)
    pub delta_v2: f64,
    /// Transfer time (seconds)
    pub transfer_time: f64,
}

/// Current spacecraft state
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SpacecraftState {
    /// Current altitude above Earth (meters)
    pub altitude: f64,
    /// Current speed (m/s)
    pub speed: f64,
    /// Current flight path angle (degrees)
    pub flight_path_angle: f64,
    /// Available ΔV (m/s)
    pub available_delta_v: f64,
    /// Thrust-to-weight ratio
    pub thrust_to_weight: f64,
    /// Current orbit description
    pub orbit_description: String,
}

/// Orbital parameters
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct OrbitalParameters {
    pub velocity: f64,
    pub period_minutes: f64,
    pub description: String,
}

/// Calculate Hohmann transfer between two circular orbits
pub fn calculate_hohmann_transfer(orbit_radius1: f64, orbit_radius2: f64) -> TransferInfo {
    let g: f64 = 6.67430e-11;
    let earth_mass: f64 = 5.972e24;

    let semi_major_axis = (orbit_radius1 + orbit_radius2) / 2.0;

    // Initial circular orbit velocity
    let v1 = (g * earth_mass / orbit_radius1).sqrt();

    // Transfer orbit velocity at periapsis
    let v_transfer_periapsis = (g * earth_mass * (2.0 / orbit_radius1 - 1.0 / semi_major_axis)).sqrt();

    // ΔV calculations
    let delta_v1 = v_transfer_periapsis - v1;

    // Final circular orbit velocity
    let v2 = (g * earth_mass / orbit_radius2).sqrt();

    // Transfer orbit velocity at apoapsis
    let v_transfer_apoapsis = (g * earth_mass * (2.0 / orbit_radius2 - 1.0 / semi_major_axis)).sqrt();

    let delta_v2 = v2 - v_transfer_apoapsis;

    // Transfer time (half the period of the transfer orbit)
    let transfer_time = PI * (semi_major_axis * semi_major_axis * semi_major_axis / (g * earth_mass)).sqrt();

    TransferInfo {
        orbit_radius1,
        orbit_radius2,
        delta_v1,
        delta_v2,
        transfer_time,
    }
}

/// Update spacecraft state based on thrust and time
pub fn update_spacecraft_state(
    current_altitude: f64,
    current_speed: f64,
    current_angle: f64,
    thrust: f64,
    mass: f64,
    delta_t: f64,
) -> SpacecraftState {
    let g: f64 = 6.67430e-11;
    let earth_mass: f64 = 5.972e24;
    let earth_radius: f64 = 6371000.0;

    // gravitational parameter
    let mu = g * earth_mass;

    // gravitational acceleration at current altitude
    let distance_from_center = earth_radius + current_altitude;
    let gravitational_acceleration = mu / (distance_from_center * distance_from_center);

    // thrust acceleration
    let thrust_acceleration = thrust / mass;

    // net acceleration (simplified - doesn't include direction fully)
    let net_acceleration = thrust_acceleration - gravitational_acceleration;

    // velocity change
    let _velocity_change = net_acceleration * delta_t;

    // new speed (simplified)
    let new_speed = current_speed + net_acceleration * delta_t;

    // simple altitude change approximation
    let new_altitude = current_altitude + new_speed * delta_t;

    // orbit description
    let orbit_description = if new_altitude > earth_radius * 0.1 {
        "Low Earth Orbit".to_string()
    } else {
        "Suborbital".to_string()
    };

    SpacecraftState {
        altitude: new_altitude,
        speed: new_speed.max(0.0), // ensure non-negative
        flight_path_angle: current_angle,
        available_delta_v: 9200.0 - delta_t * thrust, // simplified ΔV consumption
        thrust_to_weight: thrust / (mass * gravitational_acceleration / 9.81),
        orbit_description,
    }
}

/// Get current orbital parameters for display
pub fn get_orbital_parameters(altitude: f64) -> OrbitalParameters {
    let earth_radius: f64 = 6371000.0;
    let orbital_radius = earth_radius + altitude;

    // circular orbit velocity
    let g: f64 = 6.67430e-11;
    let earth_mass: f64 = 5.972e24;
    let velocity = (g * earth_mass / orbital_radius).sqrt();

    // orbital period for circular orbit
    let period = 2.0 * PI * orbital_radius / velocity;

    // convert period to minutes
    let period_minutes = period / 60.0;

    OrbitalParameters {
        velocity,
        period_minutes,
        description: format!("{} km orbit", (orbital_radius / 1000.0).round()),
    }
}

/// Shared data file path
const SHARED_DATA_FILE: &str = "/tmp/rendezvous_shared_data.json";

/// Write shared data to file
pub fn write_shared_data(data: &str) {
    let path = Path::new(SHARED_DATA_FILE);
    let mut file = File::create(path).expect("Failed to create shared data file");
    file.write_all(data.as_bytes()).expect("Failed to write shared data");
}

/// Read shared data from file
pub fn read_shared_data() -> String {
    let path = Path::new(SHARED_DATA_FILE);
    let mut file = File::open(path).expect("Failed to open shared data file");
    let mut contents = String::new();
    file.read_to_string(&mut contents).expect("Failed to read shared data");
    contents
}