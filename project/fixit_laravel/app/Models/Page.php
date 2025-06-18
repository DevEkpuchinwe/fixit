<?php

namespace App\Models;

use Spatie\MediaLibrary\HasMedia;
use Spatie\Translatable\HasTranslations;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\InteractsWithMedia;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Http\Traits\HandlesLegacyTranslations;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Page extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia, SoftDeletes, HasTranslations, HandlesLegacyTranslations;

    public $translatable = [
        'title',
        'content',
        'meta_title',
        'meta_description',
    ];

    protected $fillable = [
        'title',
        'content',
        'image',
        'status',
        'created_by_id',
        'meta_title',
        'meta_description',
    ];

    protected $with = [
        'media'
    ];

    protected $casts = [
        'created_by_id' => 'integer',
        'status' => 'integer',
    ];

    protected $hidden = [
        'metatitle',
        'metadescripation',
        'meta_title',
        'meta_description',
    ];

    public function toArray()
    {
        $attributes = parent::toArray();
        $locale = request()->header('Accept-Lang') ? request()->header('Accept-Lang') : request('locale');

        // Filter media based on the language in custom_properties
        if (isset($attributes['media']) && is_array($attributes['media'])) {
            $attributes['media'] = array_filter($attributes['media'], function ($media) use ($locale) {
                return isset($media['custom_properties']['language']) 
                    && $media['custom_properties']['language'] === $locale;
            });

            // Re-index the array to avoid gaps in indices after filtering
            $attributes['media'] = array_values($attributes['media']);
        }

        return  $this->handleModelTranslations($this, $attributes, $this->translatable);
    }
}
