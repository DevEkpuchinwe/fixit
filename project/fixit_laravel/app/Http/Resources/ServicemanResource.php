<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;

class ServicemanResource extends BaseResource
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
            'name' => $this->name,
            'email' => $this->email,
            'phone' => $this->phone,
            'code' => $this->code,
            'system_reserve' => $this->system_reserve,
            'status' => $this->status,
            'is_featured' => $this->is_featured,
            'created_by' => $this->created_by,
            'type' => $this->type,
            'experience_interval' => $this->experience_interval,
            'experience_duration' => $this->experience_duration,
            'company_name' => $this->company_name,
            'company_email' => $this->company_email,
            'company_phone' => $this->company_phone,
            'company_code' => $this->company_code,
            'description' => $this->description,
            'served' => $this->served,
            'fcm_token' => $this->fcm_token,
            'company_id' => $this->company_id,
            'location_cordinates' => $this->location_cordinates,
            'provider' => $this->provider,
            'media' => $this->getMediaAttributes(),
            'role' => $this->role,
            'review_ratings' => $this->review_ratings,
            'service_man_rating_list' => $this->service_man_rating_list,
            'primary_address' => $this->primary_address,
            'total_days_experience' => $this->total_days_experience,
            'ServicemanReviewRatings' => $this->ServicemanReviewRatings,
        ];
    }

    public function getMediaAttributes()
    {
        if ($this->media) {
            return $this->media->map(function ($media) {
                return collect($media)->except([
                    'model_type',
                    'model_id',
                    'uuid',
                    'file_name',
                    'mime_type',
                    'disk',
                    'conversions_disk',
                    'updated_at',
                    'preview_url'
                ]);
            });
        }
    }
}
