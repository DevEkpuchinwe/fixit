<?php

namespace App\Repositories\API;

use App\Enums\CategoryType;
use App\Enums\RoleEnum;
use App\Exceptions\ExceptionHandler;
use App\Http\Resources\UserDashboardBannerResource;
use App\Http\Resources\UserDashboardBlogResource;
use App\Http\Resources\UserDashboardCategoryResource;
use App\Http\Resources\UserDashboardCouponResource;
use App\Http\Resources\UserDashboardFeaturedServiceResource;
use App\Http\Resources\UserDashboardServicePackageResource;
use App\Models\Address;
use App\Models\Banner;
use App\Models\Blog;
use App\Models\Category;
use App\Models\Service;
use App\Models\ServicePackage;
use App\Models\User;
use Exception;
use Illuminate\Support\Facades\DB;
use Modules\Coupon\Entities\Coupon;
use Prettus\Repository\Eloquent\BaseRepository;
use Spatie\Permission\Models\Role;

class UserRepository extends BaseRepository
{
    protected $fieldSearchable = [
        'name' => 'like',
    ];

    protected $role;

    protected $banner;

    protected $coupon;

    protected $category;

    protected $servicePackage;

    protected $service;

    protected $provider;

    protected $blog;

    protected $address;

    public function model()
    {
        $this->blog = new Blog();
        $this->role = new Role();
        $this->banner = new Banner();
        $this->coupon = new Coupon();
        $this->service = new Service();
        $this->address = new Address();
        $this->category = new Category();
        $this->provider = new User();
        $this->servicePackage = new ServicePackage();
        return User::class;
    }

    public function getAllUsers()
    {
        DB::beginTransaction();
        try {
            return $this->model->role('user')->with('addresses');
        } catch (Exception $e) {
            throw new ExceptionHandler($e->getMessage(), $e->getCode());
        }
    }

    public function destroy($id)
    {
        try {

            $user = $this->model->findOrFail($id);
            if ($user->hasRole(RoleEnum::ADMIN)) {
                throw new Exception(__('static.users.reserved_user_not_deleted'), 400);
            }

            return $user->destroy($id);

        } catch (Exception $e) {

            throw new ExceptionHandler($e->getMessage(), $e->getCode());
        }
    }

    public function getDashboardData()
    {
        try {
            // Banners
            $banners = cache()->remember('dashboard_banners', 60, function () {
                return $this->banner->where('is_offer', false)->select('id', 'title', 'type', 'related_id')
                                    ->latest()
                                    ->with('media')
                                    ->get();
            });
    
            // Coupons
            $coupons = cache()->remember('dashboard_coupons', 60, function () {
                return $this->coupon->select('id', 'code', 'min_spend', 'type', 'amount')
                                    ->get();
            });
    
            // Categories with Media
            $categories = cache()->remember('dashboard_categories', 60, function () {
                return $this->category->where(['category_type' => CategoryType::SERVICE, 'status' => true])
                                      ->whereNull('parent_id')
                                      ->latest()
                                      ->take(8)
                                      ->with('media','hasSubCategories')
                                      ->get();
            });
    
            // Service Packages with Media
            $servicePackages = cache()->remember('dashboard_service_packages', 60, function () {
                return $this->servicePackage->select('id', 'hexa_code', 'title', 'price', 'description', 'provider_id') 
                                            ->latest()
                                            ->take(4)
                                            ->with('media', 'user', 'services')
                                            ->get();
            });

            // Featured Services with Media
            $featuredServices = cache()->remember('dashboard_services', 60, function () {
                return $this->service->where('is_featured', true)
                                 ->select('id', 'title', 'price', 'duration', 'duration_unit', 'discount', 'required_servicemen', 'service_rate', 'description')
                                 ->latest()
                                 ->take(2)
                                 ->with('media')
                                 ->get();
            });

            // Providers with Highest Ratings
            $highestRatedProviders = cache()->remember('dashboard_highest_rated_providers', 60, function () {
                return $this->provider->role('provider')
                                      ->with(['media', 'expertise', 'reviews'])
                                      ->whereHas('reviews')
                                      ->get()
                                      ->filter(function ($provider) {
                                          return $provider->review_ratings > 0;
                                      })
                                      ->sortByDesc('review_ratings')
                                      ->take(2)
                                      ->values();
            });
    
            // Blogs with Media and Tags
            $blogs = cache()->remember('dashboard_blogs', 60, function () {
                return $this->blog->select('id', 'title', 'description','slug','content','meta_title','meta_description','is_featured','status','created_by_id', 'created_at')
                                  ->with(['media', 'tags', 'created_by','categories'])
                                  ->get();
            });
            return response()->json([
                'banners' => UserDashboardBannerResource::collection($banners),
                'coupons' => UserDashboardCouponResource::collection($coupons),
                'categories' => UserDashboardCategoryResource::collection($categories),
                'servicePackages' => UserDashboardServicePackageResource::collection($servicePackages),
                'featuredServices' => UserDashboardFeaturedServiceResource::collection($featuredServices),
                'highestRatedProviders' => $highestRatedProviders,
                'blogs' => UserDashboardBlogResource::collection($blogs),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to retrieve dashboard data.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
