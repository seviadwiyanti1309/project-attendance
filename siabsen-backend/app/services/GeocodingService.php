<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class GeocodingService
{
    /**
     * Get human-readable address from latitude and longitude coordinates.
     *
     * @param float|string|null $latitude
     * @param float|string|null $longitude
     * @return string|null
     */
    public function getAddress($latitude, $longitude): ?string
    {
        if (empty($latitude) || empty($longitude)) {
            return null;
        }

        try {
            $response = Http::withHeaders([
                'User-Agent' => 'SiAbsen-AttendanceApp/1.0',
                'Accept-Language' => 'id,en',
            ])->timeout(5)->get('https://nominatim.openstreetmap.org/reverse', [
                'lat' => $latitude,
                'lon' => $longitude,
                'format' => 'json',
                'addressdetails' => 1,
            ]);

            if ($response->successful()) {
                $data = $response->json();

                if (!empty($data['display_name'])) {
                    return $data['display_name'];
                }
            }
        } catch (\Throwable $e) {
            Log::warning('Geocoding error: ' . $e->getMessage(), [
                'latitude' => $latitude,
                'longitude' => $longitude,
            ]);
        }

        return null;
    }
}
