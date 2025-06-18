<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserDashboardFeaturedServiceResource extends JsonResource
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
            'id' => $this?->id,
            'duration' => $this?->duration,
            'duration_unit' => $this?->duration_unit,
            'required_servicemen' => $this?->required_servicemen,
            'title' => $this?->getTranslation('title', $locale),
            'discount' => $this?->discount,
            'discount' => $this?->discount,
            'required_servicemen' => $this?->required_servicemen,
            'price' => $this?->price,
            'service_rate' => $this?->service_rate,
            'description' => $this?->getTranslation('description', $locale),
            'media' => $this?->getFilteredMedia($locale),
        ];
    }

    private function getFilteredMedia($locale)
    {
        return $this->whenLoaded('media', function () use ($locale) {
            return $this->media->filter(function ($media) use ($locale) {
                return isset($media->custom_properties['language']) &&
                    $media->custom_properties['language'] === $locale;
            })->map(function ($media) {
                return collect($media)->only(['original_url', 'collection_name', 'id']);
            })->values();
        }, []);
    }
}
