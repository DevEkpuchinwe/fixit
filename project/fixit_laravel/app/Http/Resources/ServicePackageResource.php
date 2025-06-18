<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ServicePackageResource extends BaseResource
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
            'title' => $this->getTranslation('title', $locale),
            'description' => $this->getTranslation('description', $locale),
            'price' => $this->price,
            'status' => $this->status,
            'discount' => $this->discount,
            'hexa_code' => $this->hexa_code,
            'bg_color' => $this->bg_color,
            'started_at' => $this->started_at,
            'ended_at' => $this->ended_at,
            'media' => $this->getFilteredMedia($locale),
            'services' => $this->whenLoaded('services'),
            'user' => $this->whenLoaded('user'),
        ];
    }

    /**
     * Filter media based on locale.
     */
    private function getFilteredMedia($locale)
    {
        return $this->whenLoaded('media', function () use ($locale) {
            return $this->media->filter(function ($media) use ($locale) {
                return isset($media->custom_properties['language']) &&
                       $media->custom_properties['language'] === $locale;
            })->map(function ($media) {
                return collect($media)->except([
                    'model_type',
                    'model_id',
                    'uuid',
                    'file_name',
                    'manipulations',
                    'generated_conversions',
                    'order_column',
                    'size',
                    'mime_type',
                    'disk',
                    'conversions_disk',
                    'updated_at',
                    'preview_url'
                ]);
            })->values();
        }, []);
    }
}
