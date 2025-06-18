<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class BlogResource extends JsonResource
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
            'description' => $this->description,
            'created_at' => $this->created_at,
            'content' => $this?->content,
            'categories' => $this?->categories,
            'created_by' => [
                'name' => $this->created_by->name,
            ],
            'tags' => $this?->whenLoaded('tags'),
            'media' => $this->getFilteredMedia($locale),
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
