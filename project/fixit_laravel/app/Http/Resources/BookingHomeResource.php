<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class BookingHomeResource extends JsonResource
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
            'booking_number' => $this?->booking_number,
            'parent_booking_number' => $this?->parent?->booking_number ?? null,
            'total_servicemen' => $this?->total_servicemen ?? null,
            'total' => $this?->total ?? null,
            'address' => $this?->address ?? null,
            'service' => [
                'id' => $this?->id,
                'title' => $this?->service?->title,
                'media' => $this?->getFilteredServiceMedia($locale),
            ],
            'booking_status' => $this?->whenLoaded('booking_status'),
            'required_servicemen' => $this?->required_servicemen,
            'date_time' => $this?->date_time,
            'payment_method' => $this?->payment_method,
            'payment_status' => $this?->payment_status,
            'consumer' => [
                'id' => $this?->id,
                'name' => $this?->consumer->name,
                'media' => $this?->getFilteredConsumerMedia($locale),
            ],
            'servicemen' => $this?->servicemen->map(function ($serviceman) {
                return [
                    'id' => $serviceman->id,
                    'name' => $serviceman->name,
                ];
            }),
            'provider' => [
                'id' => $this?->provider->id,
                'name' => $this?->provider->name,
            ],
            'coupon' => $this?->coupon ?? null,
        ];
    }

    private function getFilteredServiceMedia($locale)
    {
        return $this->service && $this->service->relationLoaded('media')
            ? $this->filterMedia($this->service->media, $locale)
            : [];
    }

    private function getFilteredConsumerMedia($locale)
    {
        return $this->consumer && $this->consumer->relationLoaded('media')
            ? $this->filterMedia($this->consumer->media, $locale)
            : [];
    }

    private function filterMedia($mediaCollection, $locale)
    {
        return $mediaCollection->filter(function ($media) use ($locale) {
            return isset($media->custom_properties['language']) &&
                $media->custom_properties['language'] === $locale;
        })->map(function ($media) {
            return collect($media)->except([
                'model_type', 'model_id', 'uuid', 'file_name', 'manipulations',
                'generated_conversions', 'order_column', 'size', 'mime_type',
                'disk', 'conversions_disk', 'updated_at', 'preview_url'
            ]);
        })->values();
    }
}
