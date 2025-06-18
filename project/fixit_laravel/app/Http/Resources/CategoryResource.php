<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;

class CategoryResource extends BaseResource
{
    protected $showSensitiveAttributes = true;

    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'status' => $this->status,
            'created_by' => $this->created_by,
            'services_count' => $this->services_count,
            'has_sub_categories' => CategoryResource::collection($this->whenLoaded('hasSubCategories')),
            'media' => $this->getMediaAttributes(),
        ];
    }

    /**
     * Filter media attributes.
     */
    public function getMediaAttributes()
    {
        $locale = request()->header('Accept-Lang') ? request()->header('Accept-Lang') : app()->getLocale();

        return $this->whenLoaded('media', function () use ($locale) {
            return $this->media->filter(function ($media) use ($locale) {
                return isset($media->custom_properties['language']) && $media->custom_properties['language'] === $locale;})
                    ->map(function ($media) {
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
                                    ]);})->values();
            }, []);
    }
}