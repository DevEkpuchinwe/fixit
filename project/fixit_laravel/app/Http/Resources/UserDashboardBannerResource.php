<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserDashboardBannerResource extends JsonResource
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
            'type' => $this->type,
            'related_id' => $this->related_id,
            'title' => $this->getTranslation('title', $locale),
            'media' => $this->getFilteredMedia($locale),
        ];
    }

    private function getFilteredMedia($locale)
    {
        return $this->whenLoaded('media', function () use ($locale) {
            return $this->media->filter(function ($media) use ($locale) {
                return isset($media->custom_properties['language']) &&
                    $media->custom_properties['language'] === $locale;
            })->map(function ($media) {
                return collect($media)->only(['original_url', 'id']);
            })->values();
        }, []);
    }
}
