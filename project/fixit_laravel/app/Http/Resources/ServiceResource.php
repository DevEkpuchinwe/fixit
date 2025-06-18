<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ServiceResource extends JsonResource
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
            'title' => $this->fetchTranslation('title'),
            'price' => $this->price,
            'status' => $this->status,
            'duration' => $this->duration,
            'duration_unit' => $this->duration_unit,
            'discount' => $this->discount,
            'per_serviceman_commission' => $this->per_serviceman_commission,
            'description' => $this->fetchTranslation('description'),
            'content' => $this->content,
            'speciality_description' => $this->speciality_description,
            'address_id' => $this->address_id,
            'user_id' => $this->user_id,
            'parent_id' => $this->parent_id,
            'type' => $this->type,
            'is_featured' => $this->is_featured,
            'created_by_id' => $this->created_by_id,
            'is_random_related_services' => $this->is_random_related_services,
            'meta_title' => $this->meta_title,
            'meta_description' => $this->meta_description,
            'tax_id' => $this->tax_id,
            'service_rate' => $this->service_rate,
            'slug' => $this->slug,
            'required_servicemen' => $this->required_servicemen,
            'service_type' => $this->service_type,
            'media' => $this->getMediaAttributes(),
        ];
    }

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

    public function fetchTranslation($key)
    {
        $translation = $this->getTranslation($key, app()->getLocale());
        $defaultTranslation = $translation ?? $services[$key];

        if (empty($defaultTranslation)) {
            return $this->getDatabaseValue($key);
        }

        return $defaultTranslation;
    }
}
