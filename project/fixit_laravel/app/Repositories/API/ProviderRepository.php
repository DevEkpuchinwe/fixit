<?php

namespace App\Repositories\API;

use Exception;
use App\Enums\CategoryType;
use App\Enums\PaymentStatus;
use App\Enums\RoleEnum;
use App\Events\CreateProviderEvent;
use App\Exceptions\ExceptionHandler;
use App\Helpers\Helpers;
use App\Http\Resources\BlogResource;
use App\Http\Resources\BookingHomeResource;
use App\Http\Resources\PopularServiceResource;
use App\Http\Resources\ServiceRequestHomeResource;
use App\Models\Address;
use App\Models\Blog;
use App\Models\Booking;
use App\Models\Category;
use App\Models\CommissionHistory;
use App\Models\Company;
use App\Models\Service;
use App\Models\ServiceRequest;
use App\Models\TimeSlot;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Spatie\Permission\Models\Role;
use Prettus\Repository\Eloquent\BaseRepository;
use Symfony\Component\HttpFoundation\Response;

class ProviderRepository extends BaseRepository
{
    protected $fieldSearchable = [
        'name' => 'like',
        'email' => 'like',
    ];

    protected $role;

    protected $commissionhistory;

    protected $service;

    protected $blog;

    protected $serviceRequest;

    protected $address;

    protected $timeslot;

    protected $booking;

    protected $category;

    public function model()
    {
        $this->address = new Address();
        $this->role = new Role();
        $this->service = new Service();
        $this->timeslot = new TimeSlot();
        $this->booking = new Booking();
        $this->category = new Category();
        $this->commissionhistory = new CommissionHistory();
        $this->serviceRequest = new ServiceRequest();
        $this->blog = new Blog();
        return User::class;
    }

    public function store($request)
    {
        DB::beginTransaction();
        try {
            $user = $this->model->create([
                'name' => $request->name,
                'email' => $request->email,
                'country_code' => $request->country_code,
                'phone' => (string) $request->phone,
                'code' => $request->countryCode,
                'status' => $request->status,
                'password' => Hash::make($request->password),
            ]);

            $role = $this->role->where('name', RoleEnum::PROVIDER)->first();
            $user->assignRole($role);

            if ($request->hasFile('image') && $request->file('image')->isValid()) {
                $user->addMediaFromRequest('image')->toMediaCollection('image');
            }

            $address = $this->address->create([
                'user_id' => $user->id,
                'latitude' => $request->latitude,
                'longitude' => $request->longitude,
                'area' => $request->area,
                'postal_code' => $request->postal_code,
                'country_id' => $request->country_id,
                'state_id' => $request->state_id,
                'city' => $request->city,
                'address' => $request->address,
                'type' => $request->type,
                'is_primary' => 1,
            ]);

            event(new CreateProviderEvent($user));
            DB::commit();

            return response()->json($user);
        } catch (Exception $e) {
            throw new ExceptionHandler($e->getMessage(), $e->getCode());
        }
    }

    public function show($id)
    {
        try {
            return $this->model->role('provider')->with(['addresses'])->findOrFail($id);
        } catch (Exception $e) {

            throw new ExceptionHandler($e->getMessage(), $e->getCode());
        }
    }

    public function isValidTimeSlot($request)
    {
        $bookings = $this->booking->where('provider_id', $request->provider_id)->get();
        $dateTime = Carbon::parse($request->dateTime);

        foreach ($bookings as $booking) {
            $bookingDateTime = Carbon::parse($booking->dateTime);

            if ($dateTime->eq($bookingDateTime)) {
                return response()->json([
                    'success' => true,
                    'isValidTimeSlot' => false,
                ]);
            }
        }

        return response()->json(['success' => true, 'isValidTimeSlot' => true]);
    }

    public function providerTimeslot($providerId)
    {
        $providerTimeSlot = $this->timeslot->where('provider_id', $providerId)->first();

        return $providerTimeSlot;
    }

    public function storeProviderTimeSlot($request)
    {
        DB::beginTransaction();
        try {
            $provider_id = Helpers::getCurrentUserId();
            $this->timeslot->create([
                'time_unit' => $request->time_unit,
                'gap' => $request->gap,
                'time_slots' => $request->time_slots,
                'provider_id' => $provider_id,
            ]);

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => __('static.provider.time_slot_created'),
            ]);
        } catch (Exception $e) {

            DB::rollback();

            throw $e;
        }
    }

    public function updateProviderTimeSlot($request)
    {
        DB::beginTransaction();
        try {
            $roleName = Helpers::getCurrentRoleName();
            if ($roleName == RoleEnum::PROVIDER) {
                $provider_id = Helpers::getCurrentUserId();
                $timeSlot = $this->timeslot->where('provider_id', $provider_id)->first();
                if ($timeSlot) {
                    $timeSlot->update([
                        'gap' => $request['gap'],
                        'time_unit' => $request['time_unit'],
                        'time_slots' => $request['time_slots'],
                    ]);
                    DB::commit();

                    return response()->json([
                        'success' => true,
                        'message' => __('static.provider.time_slot_updated'),
                    ]);
                } else {
                    return response()->json([
                        'message' => __('static.provider.create_time_slot'),
                        'success' => false,
                    ]);
                }
            } else {
                return response()->json([
                    'message' => __('static.provider.auth_is_not_provider'),
                    'success' => false,
                ]);
            }
        } catch (Exception $e) {

            DB::rollback();
            throw $e;
        }
    }

    public function updateTimeSlotStatus($status, $timeslotID)
    {
        DB::beginTransaction();
        try {
            $timeSlot = $this->timeslot->findOrFail($timeslotID);
            $provider_id = Helpers::getCurrentUserId();
            $timeSlot->update(['status' => $status]);

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => __('static.provider.time_slot_status_updated'),
            ]);
        } catch (Exception $e) {

            DB::rollback();
            throw $e;
        }
    }

    public function getUsersWithHighestRatings($request)
    {
        $searchQuery = $request->search;

        $expertServicer = $this->model->role('provider')->with('services')
            ->when($searchQuery, function ($query) use ($searchQuery) {
                $query->where('name', 'like', '%'.$searchQuery.'%');
            })
            ->get()
            ->filter(function ($provider) {
                return $provider->review_ratings > 0;
            })
            ->sortByDesc(function ($provider) {
                return $provider->review_ratings;
            });

        return response()->json($expertServicer);
    }

    public function getProviderServices($request)
    {
        $providerId = Helpers::getCurrentProviderId();
        $provider = $this->model::findOrFail($providerId);
        if ($request->service_id) {
            $service = $provider->services()->where('id', $request->service_id)->with('serviceAvailabilities', 'tax:id,name,rate')->first();
            if ($service) {
                return response()->json([
                    'success' => true,
                    'data' => $service,
                ]);
            } else {
                return response()->json([
                    'message' => __('static.provider.service_not_found'),
                    'success' => false,
                ]);
            }
        } else {
            if ($provider) {
                $services = $provider->services()->with(['addresses', 'user', 'serviceAvailabilities', 'tax:name']);
                if ($request->popular_service) {
                    $services = Helpers::getTopSellingServicec($provider->services());
                }

                if ($request->category_id) {
                    $categoryId = $request->category_id;
                    $services->whereHas('categories', function ($query) use ($categoryId) {
                        $query->where('category_id', $categoryId);
                    });
                }

                if ($request->search) {
                    $services->where('title', 'like', '%'.$request->search.'%');
                }

                return $services->latest('created_at')->paginate($request->paginate ?? $services->count());
            } else {
                return response()->json([
                    'message' => __('static.provider.invalid_provider'),
                    'success' => false,
                ]);
            }
        }
    }

    public function updateProviderZones($request)
    {
        $user_id = Helpers::getCurrentUserId();
        $provider = $this->model->findOrFail($user_id);
        if ($provider) {
            $roleName = Helpers::getCurrentRoleName();
            if ($roleName == RoleEnum::PROVIDER) {
                if (isset($request->zoneIds)) {
                    $provider->zones()->sync([]);
                    $provider->zones()->sync($request->zoneIds);

                    return response()->json([
                        'message' => __('static.provider.zone_id_updated'),
                        'success' => false,
                    ]);
                }

                return response()->json([
                    'message' => __('static.provider.zone_id_must_be_required'),
                    'success' => false,
                ]);
            }

            return response()->json([
                'message' => __('static.provider.must_be_provider'),
                'success' => false,
            ]);
        }

        return response()->json([
            'message' => __('static.provider.not_found'),
            'success' => false,
        ]);
    }

    public function updateCompanyDetails($request)
    {
        $provider = Helpers::getCurrentUser();
        if (!$provider) {
            return response()->json([
                'message' => __('static.provider.not_found'),
                'success' => false,
            ]);
        }
        $roleName = Helpers::getCurrentRoleName();
        if ($roleName !== RoleEnum::PROVIDER) {
            return response()->json([
                'message' => __('static.provider.must_be_provider'),
                'success' => false,
            ]);
        }
        // Check if company exists, create if not
        $company = $provider->company ?? new Company();
        $company->fill([
            'name'        => $request->name,
            'email'       => $request->email,
            'phone'       => $request->phone,
            'code'        => $request->code,
            'description' => $request->description,
        ]);
        $company->save();
        // Handle company logo update if provided
        if ($request->hasFile('company_logo')) {
            $company->clearMediaCollection('company_logo');
            $company->addMedia($request->file('company_logo'))->toMediaCollection('company_logo');
        }
        // Refresh to get updated data
        $company = $company->refresh();
        // Check if address exists, create if not
        
        $address = $this->address->where('company_id', $company->id)->first();
        if ($address) {
            // Update existing address
            $address->update([
                'company_id'    => $company->id,
                'latitude'      => $request?->company_address['latitude'],
                'longitude'     => $request?->company_address['longitude'],
                'address'       => $request?->company_address['address'],
                'area'          => $request?->company_address['area'],
                'country_id'    => $request?->company_address['country_id'],
                'state_id'      => $request?->company_address['state_id'],
                'city'          => $request?->company_address['city'],
                'postal_code'   => $request?->company_address['postal_code'],
                'status'        => true,
                'is_primary'    => true,
            ]);
        } else {
            // Create new address
            $address = $this->address->create([
                'company_id'    => $company->id,
                'latitude'      => $request?->company_address['latitude'],
                'longitude'     => $request?->company_address['longitude'],
                'address'       => $request?->company_address['address'],
                'area'          => $request?->company_address['area'],
                'country_id'    => $request?->company_address['country_id'],
                'state_id'      => $request?->company_address['state_id'],
                'city'          => $request?->company_address['city'],
                'postal_code'   => $request?->company_address['postal_code'],
                'status'        => true,
                'is_primary'    => true,
            ]);
        }
        return response()->json([
            'message' => 'Updated Successfully',
            'success' => true,
            'company' => $company,
            'address' => $address,
        ]);
    }

    public function getMonthlyRevenues($roleName)
    {
        $months = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December',
        ];

        $perMonthRevenues = [];
        foreach ($months as $key => $month) {
            $perMonthRevenues[$month] = (float) $this->getCompleteBooking($roleName)
                ->whereMonth('created_at', $key + 1)
                ->whereYear('created_at', Carbon::now()->year)->sum('total');
        }

        return $perMonthRevenues;
    }

    public function getYearlyRevenues($roleName)
    {
        $years = range(Carbon::now()->year - 6, Carbon::now()->year);
        $perYearRevenues = [];

        foreach ($years as $year) {
            $perYearRevenues[$year] = $this->getCompleteBooking($roleName)
                ->whereYear('created_at', $year)->sum('total');
        }

        return $perYearRevenues;
    }

    public function getWeekdayRevenues($roleName)
    {
        $weekdays = [
            'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday',
        ];

        $startDate = now()->subDays(7)->startOfDay();
        $endDate = now()->endOfDay();

        $perWeekdayRevenues = [];

        foreach ($weekdays as $key => $weekday) {
            $perWeekdayRevenues[$weekday] = (float) $this->getCompleteBooking($roleName)
                ->whereBetween('created_at', [$startDate, $endDate])
                ->whereRaw('DAYOFWEEK(created_at) = ?', [$key + 1])
                ->sum('total');
        }

        return $perWeekdayRevenues;
    }

    public function getDashboardData()
    {
        $roleName = Helpers::getCurrentRoleName();
        if($roleName == RoleEnum::PROVIDER){
            $providerId = Helpers::getCurrentProviderId();
            $provider = $this->model->findOrFail($providerId);
            $totalRevenue = $this->commissionhistory->where('provider_id', Helpers::getCurrentProviderId())->sum('provider_commission');
            $totalBookings = $this->getTotalBookings($roleName);
            $totalServices = $this->getTotalService($roleName);
            $totalCategories = $this->getTotalCategories($roleName);
            $totalServicemen = $this->getTotalServicemen($roleName);
            $getchartData['monthlyRevenues'] = $this->getMonthlyRevenues($roleName);
            $getchartData['yearlyRevenues'] = $this->getYearlyRevenues($roleName);
            $getchartData['weekdayRevenues'] = $this->getWeekdayRevenues($roleName);
            $latestBookings = $this->booking->whereNotNull('parent_id')->with('service.media')->latest('created_at')->take(2)->get();
            $getServiceRequestData = $this->serviceRequest->whereNull('deleted_at')->latest('created_at')->take(2)->with(['media', 'bids', 'user', 'provider', 'service', 'zones'])->get();
            $popularServices = Helpers::getTopSellingServicec($provider->services())->take(2)->get();
            $blogs = $this->blog->get();

            return response()->json([
                'total_revenue' => $totalRevenue,
                'total_Bookings' => $totalBookings,
                'total_services' => $totalServices,
                'total_categories' => $totalCategories,
                'total_servicemen' => $totalServicemen,
                'chart' => $getchartData,
                'booking' => BookingHomeResource::collection($latestBookings),
                'latestServiceRequests' => $getServiceRequestData,
                'popularServices' => PopularServiceResource::collection($popularServices),
                'latestBlogs' => BlogResource::collection($blogs),
            ]);

        }
        return response()->json([
            "message" => __('static.provider.provider_not_found'),
            "success" => false
        ], Response::HTTP_NOT_FOUND);
    }

    public function getTotalServicemen($roleName)
    {
        if ($roleName == RoleEnum::PROVIDER) {
            $provider = Helpers::getCurrentUser();
            $servicemenCount = $provider->servicemans->count();

            return $servicemenCount;
        }

        return 0;
    }

    public function getTotalCategories($roleName)
    {
        $categories = Category::where([
            'parent_id' => null,
            'status' => true,
            'category_type' => CategoryType::SERVICE,
        ]);
        if ($roleName = RoleEnum::PROVIDER) {
            $provider = Helpers::getCurrentUser();
            $services = $provider->services;
            $serviceIds = $services->pluck('id')->toArray();
            $categories->whereExists(function ($query) use ($serviceIds) {
                $query->select(DB::raw(1))
                    ->from('service_categories')
                    ->join('services', 'services.id', '=', 'service_categories.service_id')
                    ->whereColumn('categories.id', 'service_categories.category_id')
                    ->whereIn('services.id', $serviceIds)
                    ->whereNull('services.deleted_at');
            });
        }

        return $categories->count();
    }

    public function getTotalProviders()
    {
        return User::role(RoleEnum::PROVIDER)->whereNull('deleted_at')->count();
    }

    public function getTotalService($roleName)
    {
        $services = Service::whereNull('deleted_at')->get();
        if ($roleName == RoleEnum::PROVIDER) {
            return $services->where('user_id', Helpers::getCurrentProviderId())->count();
        }

        return $services->count();
    }

    public function getTotalUsers()
    {
        $rolesToExclude = [RoleEnum::ADMIN, RoleEnum::PROVIDER];

        return User::whereHas('roles', function ($query) use ($rolesToExclude) {
            $query->whereNotIn('name', $rolesToExclude);
        })->whereNull('deleted_at')->count();
    }

    public function getTotalBookings($roleName)
    {
        return $this->getCompleteBooking($roleName)->count();
    }

    public function getCompleteBooking($roleName)
    {
        $bookings = Booking::whereNull('deleted_at')->where('payment_status', PaymentStatus::COMPLETED);
        if ($roleName == RoleEnum::PROVIDER) {
            return $bookings->whereNotNull('parent_id')->where('provider_id', Helpers::getCurrentProviderId());
        }

        return $bookings;
    }
}
