#include <cstdarg>
#include <cstdint>
#include <cstdlib>
#include <ostream>
#include <new>

using libc_char = char;

extern "C" {

/// Calculate Hohmann transfer between two circular orbits (FFI)
/// Returns delta_v1, delta_v2, transfer_time via out parameters
void rendezvous_hohmann_transfer(double orbit_radius1,
                                 double orbit_radius2,
                                 double *out_delta_v1,
                                 double *out_delta_v2,
                                 double *out_transfer_time);

/// Update spacecraft state based on thrust and time (FFI)
/// Returns altitude, speed, flight_path_angle, available_delta_v, thrust_to_weight, orbit_description
const libc_char *rendezvous_update_spacecraft_state(double current_altitude,
                                                    double current_speed,
                                                    double current_angle,
                                                    double thrust,
                                                    double mass,
                                                    double delta_t,
                                                    double *out_altitude,
                                                    double *out_speed,
                                                    double *out_flight_path_angle,
                                                    double *out_available_delta_v,
                                                    double *out_thrust_to_weight);

/// Get orbital parameters for display (FFI)
/// Returns velocity, period_minutes, and description string
const libc_char *rendezvous_get_orbital_parameters(double altitude,
                                                   double *out_velocity,
                                                   double *out_period_minutes);

/// Free a string returned from Rust (FFI)
void rendezvous_free_string(const libc_char *ptr);

}  // extern "C"
