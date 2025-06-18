<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Support\Arr;
use Illuminate\Http\Resources\Json\JsonResource;

class SettingResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $settings = parent::toArray($request);
        $allowedCategories = array_column(\App\Enums\FrontSettingsEnum::cases(), 'value');
        $filteredSettings = Arr::only($settings, $allowedCategories);

        $values = [
            'general' => [
                'mode', 'favicon', 'copyright', 'dark_logo', 'site_name',
                'light_logo', 'platform_fees', 'default_timezone',
                'min_booking_amount', 'platform_fees_type',
                'default_currency_id', 'default_language_id'
            ],
            'activation' => [
                'coupon_enable', 'wallet_enable', 'extra_charge_status',
                'platform_fees_status', 'service_auto_approve',
                'provider_auto_approve', 'force_update_in_app',
                'maintenance_mode'
            ],
            'subscription_plan' => [
                'reminder_message', 'days_before_reminder'
            ],
        ];

        foreach ($values as $category => $keys) {
            if (isset($filteredSettings[$category])) {
                if (empty($keys)) {
                    unset($filteredSettings[$category]);
                } else {
                    foreach ($keys as $key) {
                        unset($filteredSettings[$category][$key]);
                    }
                }
            }
        }

        return $filteredSettings;
    }

    public static $wrap = 'values';
}
