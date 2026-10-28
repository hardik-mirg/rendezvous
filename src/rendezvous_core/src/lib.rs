//! Core orbital mechanics and physics for Rendezvous

use std::f64::consts::PI;
use std::ffi::CString;

/// Calculated orbital transfer data
#[derive(Debug, Clone, PartialEq)]
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
#[derive(Debug, Clone)]
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

// ============================================================================
// FFI exports for Swift integration
// ============================================================================

/// Calculate Hohmann transfer between two circular orbits (FFI)
/// Returns delta_v1, delta_v2, transfer_time via out parameters
#[unsafe(no_mangle)]
pub extern "C" fn rendezvous_hohmann_transfer(
    orbit_radius1: f64,
    orbit_radius2: f64,
    out_delta_v1: *mut f64,
    out_delta_v2: *mut f64,
    out_transfer_time: *mut f64,
) {
    let transfer = calculate_hohmann_transfer(orbit_radius1, orbit_radius2);
    unsafe {
        *out_delta_v1 = transfer.delta_v1;
        *out_delta_v2 = transfer.delta_v2;
        *out_transfer_time = transfer.transfer_time;
    }
}

/// Update spacecraft state based on thrust and time (FFI)
/// Returns altitude, speed, flight_path_angle, available_delta_v, thrust_to_weight, orbit_description
#[unsafe(no_mangle)]
pub extern "C" fn rendezvous_update_spacecraft_state(
    current_altitude: f64,
    current_speed: f64,
    current_angle: f64,
    thrust: f64,
    mass: f64,
    delta_t: f64,
    out_altitude: *mut f64,
    out_speed: *mut f64,
    out_flight_path_angle: *mut f64,
    out_available_delta_v: *mut f64,
    out_thrust_to_weight: *mut f64,
) -> *const libc_char {
    let state = update_spacecraft_state(
        current_altitude,
        current_speed,
        current_angle,
        thrust,
        mass,
        delta_t,
    );
    unsafe {
        *out_altitude = state.altitude;
        *out_speed = state.speed;
        *out_flight_path_angle = state.flight_path_angle;
        *out_available_delta_v = state.available_delta_v;
        *out_thrust_to_weight = state.thrust_to_weight;
    }
    CString::new(state.orbit_description).unwrap().into_raw() as *const libc_char
}

/// Get orbital parameters for display (FFI)
/// Returns velocity, period_minutes, and description string
#[unsafe(no_mangle)]
pub extern "C" fn rendezvous_get_orbital_parameters(
    altitude: f64,
    out_velocity: *mut f64,
    out_period_minutes: *mut f64,
) -> *const libc_char {
    let (velocity, period_minutes, description) = get_orbital_parameters(altitude);
    unsafe {
        *out_velocity = velocity;
        *out_period_minutes = period_minutes;
    }
    CString::new(description).unwrap().into_raw() as *const libc_char
}

/// Free a string returned from Rust (FFI)
#[unsafe(no_mangle)]
pub extern "C" fn rendezvous_free_string(ptr: *const libc_char) {
    if ptr.is_null() {
        return;
    }
    unsafe {
        let _ = CString::from_raw(ptr as *mut libc_char);
    }
}

type libc_char = std::os::raw::c_char;

/// Calculate Hohmann transfer between two circular orbits
pub fn calculate_hohmann_transfer(orbit_radius1: f64, orbit_radius2: f64) -> TransferInfo {
    let g: f64 = 6.67430e-11;
    let earth_mass: f64 = 5.972e24;

    let semi_major_axis = (orbit_radius1 + orbit_radius2) / 2.0;

    // Initial circular orbit velocity
    let v1 = (g * earth_mass / orbit_radius1).sqrt();

    // Transfer orbit velocity at periapsis (vis-viva equation)
    let v_transfer_periapsis = (g * earth_mass * (2.0 / orbit_radius1 - 1.0 / semi_major_axis)).sqrt();

    // ΔV calculations
    let delta_v1 = v_transfer_periapsis - v1;

    // Final circular orbit velocity
    let v2 = (g * earth_mass / orbit_radius2).sqrt();

    // Transfer orbit velocity at apoapsis (vis-viva equation)
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

/// Calculate Hohmann transfer for LEO to higher orbit (more realistic test values)
pub fn leo_to_geostationary_transfer() -> TransferInfo {
    let leo_radius: f64 = 6371000.0 + 400000.0; // 400km altitude
    let geo_radius: f64 = 6371000.0 + 35786000.0; // geostationary orbit

    calculate_hohmann_transfer(leo_radius, geo_radius)
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
pub fn get_orbital_parameters(altitude: f64) -> (f64, f64, String) {
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

    let display_string = format!("{} km orbit", (orbital_radius / 1000.0).round());

    (velocity, period_minutes, display_string)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_hohmann_transfer() {
        // Use LEO to GEO transfer (more realistic values)
        let transfer = leo_to_geostationary_transfer();
        // Both ΔV values should be positive for a valid transfer
        assert!(transfer.delta_v1 > 0.0, "ΔV1 should be positive for transfer");
        assert!(transfer.delta_v2 > 0.0, "ΔV2 should be positive for transfer");
        assert!(transfer.transfer_time > 0.0, "Transfer time should be positive");
    }

    #[test]
    fn test_leo_to_geo() {
        let transfer = leo_to_geostationary_transfer();
        // Both ΔV values should be positive
        assert!(transfer.delta_v1 > 0.0, "ΔV1 should be positive");
        assert!(transfer.delta_v2 > 0.0, "ΔV2 should be positive");
        // Total ΔV should be reasonable
        let total_dv = transfer.delta_v1 + transfer.delta_v2;
        assert!(total_dv > 0.0 && total_dv < 10000.0, "Total ΔV should be reasonable");
    }

    #[test]
    fn test_spacecraft_state_update() {
        let state = update_spacecraft_state(
            100000.0,      // 100km altitude
            7800.0,        // circular orbital speed
            0.0,           // starting angle
            100000.0,      // thrust
            5000.0,        // mass
            1.0,           // time step
        );
        assert!(state.altitude > 0.0);
        assert!(state.speed > 0.0);
        assert!(!state.orbit_description.is_empty());
    }

    #[test]
    fn test_orbital_parameters() {
        let (velocity, period, description) = get_orbital_parameters(400000.0); // 400km altitude
        assert!(velocity > 0.0);
        assert!(period > 0.0);
        assert!(!description.is_empty());
        // Low Earth Orbit velocity should be around 7.5-7.8 km/s
        assert!(velocity > 7000.0 && velocity < 8000.0, "LEO velocity should be ~7.8 km/s");
        // LEO period should be roughly 88-95 minutes
        assert!(period > 80.0 && period < 100.0, "LEO period should be ~90 minutes");
    }
}