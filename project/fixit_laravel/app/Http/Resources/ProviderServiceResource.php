<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;

class ProviderServiceResource extends BaseResource
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
            'price' => $this->price,
            'status' => $this->status,
            'duration' => $this->duration,
            'duration_unit' => $this->duration_unit,
            'discount' => $this->discount,
            'per_serviceman_commission' => $this->per_serviceman_commission,
            'description' => $this->description,
            'content' => $this->content,
            'parent_id' => $this->parent_id,
            'type' => $this->type,
            'is_featured' => $this->is_featured,
            'meta_title' => $this->meta_title,
            'slug' => $this->slug,
            'meta_description' => $this->meta_description,
            'created_by_id' => $this->created_by_id,
            'tax_id' => $this->tax_id,
            'deleted_at' => $this->deleted_at,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'destination_location' => $this->destination_location,
            'bookings_count' => $this->bookings_count,
            'reviews_count' => $this->reviews_count,
            'review_ratings' => $this->review_ratings,
            'rating_count' => $this->rating_count,
            'web_img_thumb_url' => $this->web_img_thumb_url,
            'web_img_galleries_url' => $this->web_img_galleries_url,
            'categories' => $this->categories,
            'media' => $this->media,
            'service_availabilities' => $this->service_availabilities,
            'reviews' => $this->reviews,
            'tax' => $this->tax
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
}
