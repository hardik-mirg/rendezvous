/// Orbital Mechanics and Physics for Rendezvous

use std::f64::consts::PI;

/// Constants for orbital mechanics
const G: f64 = 6.67430e-11; // Gravitational constant
const EARTH_MASS: f64 = 5.972e24; // Mass of Earth in kg
const MOON_MASS: f64 = 7.342e22; // Mass of Moon in kg

/// Hohmann transfer orbit parameters
pub struct HohmannTransfer {
    pub transfer_orbit_radius1: f64,
    pub transfer_orbit_radius2: f64,
    pub delta_v1: f64,
    pub delta_v2: f64,
    pub transfer_time: f64,
}

impl HohmannTransfer {
    /// Calculate Hohmann transfer parameters
    pub fn calculate_transfer(circular_orbit_radius: f64, target_orbit_radius: f64) -> Self {
        let semi_major_axis = (circular_orbit_radius + target_orbit_radius) / 2.0;
        let eccentricity = ((target_orbit_radius - circular_orbit_radius) / (circular_orbit_radius + target_orbit_radius)).sqrt();

        let transfer_orbit_radius1 = circular_orbit_radius;
        let transfer_orbit_radius2 = target_orbit_radius;

        // Calculate transfer orbit velocity using simplified formulas
        let v_transfer1 = (G * EARTH_MASS / transfer_orbit_radius1).sqrt() * (1.0 / (1.0 - eccentricity)).sqrt();
        let v_transfer2 = (G * MOON_MASS / transfer_orbit_radius2).sqrt() * (1.0 / (1.0 + eccentricity)).sqrt();

        // Calculate delta-v
        let v1 = (G * EARTH_MASS / circular_orbit_radius).sqrt();
        let v2 = (G * MOON_MASS / target_orbit_radius).sqrt();
        let delta_v1 = v_transfer1 - v1;
        let delta_v2 = v2 - v_transfer2;

        // Calculate transfer time
        let angular_velocity = (2.0 * PI).sqrt() / semi_major_axis;
        let transfer_time = 2.0 * PI / angular_velocity;

        HohmannTransfer {
            transfer_orbit_radius1,
            transfer_orbit_radius2,
            delta_v1,
            delta_v2,
            transfer_time,
        }
    }
}

/// Calculate Hohmann transfer delta-v for Earth to Moon
pub fn earth_to_moon_transfer() -> HohmannTransfer {
    let earth_radius = 6371000.0; // Earth radius in meters
    let moon_orbit_radius = 384400000.0; // Average Earth-Moon distance in meters
    HohmannTransfer::calculate_transfer(earth_radius, moon_orbit_radius)
}

/// Calculate orbital velocity for a given radius and mass
pub fn orbital_velocity(radius: f64, mass: f64) -> f64 {
    (G * mass / radius).sqrt()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_hohmann_transfer() {
        let transfer = earth_to_moon_transfer();
        // Debug print to check values
        println!("Transfer Orbit Radius 1: {:.2} m", transfer.transfer_orbit_radius1);
        println!("Transfer Orbit Radius 2: {:.2} m", transfer.transfer_orbit_radius2);
        println!("ΔV1: {:.2} m/s", transfer.delta_v1);
        println!("ΔV2: {:.2} m/s", transfer.delta_v2);
        println!("Transfer Time: {:.2} s", transfer.transfer_time);

        // Verify non-negative values
        assert!(transfer.delta_v1 > 0.0, "ΔV1 should be positive");
        assert!(transfer.delta_v2 > 0.0, "ΔV2 should be positive");
    }
}