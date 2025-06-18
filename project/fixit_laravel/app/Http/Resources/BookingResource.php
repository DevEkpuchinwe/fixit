<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class BookingResource extends BaseResource
{
    /**
     * Transform the resource into an array.
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'booking_number' => $this->booking_number,
            'type' => $this->type,
            'tax' => $this->tax,
            'per_serviceman_charge' => $this->per_serviceman_charge,
            'required_servicemen' => $this->required_servicemen,
            'subtotal' => $this->subtotal,
            'total' => $this->total,
            'date_time' => $this->date_time,
            'payment_method' => $this->payment_method,
            'payment_status' => $this->payment_status,
            'invoice_url' => $this->invoice_url,
            'service' => $this->whenLoaded('service'),
            'coupon' => $this->whenLoaded('coupon'),
            'provider' => $this->whenLoaded('provider'),
            'consumer' => $this->whenLoaded('consumer'),
            'servicemen' => ServicemanResource::collection($this->whenLoaded('servicemen')),
            'booking_status' => $this->whenLoaded('booking_status'),
            'address' => $this->whenLoaded('address'),
            'additional_services' => $this->additional_services,
            'serviceProofs' => $this->whenLoaded('serviceProofs'),
            'booking_status_logs' => $this->whenLoaded('booking_status_logs'),
            'booking_reasons' => $this->whenLoaded('bookingReasons'),
            'service_proofs' => $this->whenLoaded('serviceProofs'),
            'extra_charges' => $this->whenLoaded('extra_charges'),
        ];
    }
}