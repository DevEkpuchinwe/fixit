<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PopularServiceResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $locale = $request->header('Accept-Lang') ?? app()->getLocale();
        
        return [
            'id' => $this->id,
            'title' => $this->title,
            'duration' => $this->duration,
            'duration_unit' => $this->duration_unit,
            'price' => $this->price,
            'description' => $this?->description,
            'meta_description' => $this?->meta_description,
            'required_servicemen' => $this?->required_servicemen,
            'media' => $this->getFilteredMedia($locale),
            'booking_count' => $this->bookings_count,
            'status' => $this->status,
            'categories' => $this?->categories ?? null, 
            'rating_count' => $this?->rating_count ?? null,
            'bookings_count' => $this?->bookings_count ?? null,
            'reviews' => $this?->reviews,
            'tax' => $this?->tax ?? null,
        ];
    }

    public function getFilteredMedia($locale)
    {
        return $this->whenLoaded('media', function () use ($locale) {
            return $this->media->filter(function ($media) use ($locale) {
                return isset($media->custom_properties['language']) &&
                    $media->custom_properties['language'] === $locale;
            })->map(function ($media) {
                return collect($media)->except([
                    'model_type', 'model_id', 'uuid', 'file_name', 'manipulations',
                    'generated_conversions', 'order_column', 'size', 'mime_type',
                    'disk', 'conversions_disk', 'updated_at', 'preview_url'
                ]);
            })->values();
        }, []);
    }
}
