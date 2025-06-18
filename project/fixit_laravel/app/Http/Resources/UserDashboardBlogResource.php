<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserDashboardBlogResource extends JsonResource
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
            'title' => $this?->getTranslation('title', $locale),
            'description' => $this?->getTranslation('description', $locale),
            'content' => $this?->getTranslation('content', $locale),
            'created_at' => $this?->created_at,
            'created_by' => $this?->created_by,
            'tags' => $this?->tags,
            'media' => $this?->getFilteredMedia($locale),
            'categories' => $this?->categories->map(function ($category) {
                return collect($category)->only(['id', 'title']);
            }),
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
