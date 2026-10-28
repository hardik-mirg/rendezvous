// rendezvous_bridge.h
// C wrapper for Rust FFI functions

#ifndef RENDEZVOUS_BRIDGE_H
#define RENDEZVOUS_BRIDGE_H

#include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

// Calculate Hohmann transfer
void rendezvous_hohmann_transfer(
    double orbit_radius1,
    double orbit_radius2,
    double *out_delta_v1,
    double *out_delta_v2,
    double *out_transfer_time
);

// Update spacecraft state
char *rendezvous_update_spacecraft_state(
    double current_altitude,
    double current_speed,
    double current_angle,
    double thrust,
    double mass,
    double delta_t,
    double *out_altitude,
    double *out_speed,
    double *out_flight_path_angle,
    double *out_available_delta_v,
    double *out_thrust_to_weight
);

// Get orbital parameters
char *rendezvous_get_orbital_parameters(
    double altitude,
    double *out_velocity,
    double *out_period_minutes
);

// Free a string returned from Rust
void rendezvous_free_string(char *ptr);

#ifdef __cplusplus
}
#endif

#endif // RENDEZVOUS_BRIDGE_H