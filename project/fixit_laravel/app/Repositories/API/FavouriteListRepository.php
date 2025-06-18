<?php

namespace App\Repositories\API;

use App\Enums\FavouriteListEnum;
use App\Exceptions\ExceptionHandler;
use App\Helpers\Helpers;
use App\Models\FavouriteList;
use Exception;
use Illuminate\Support\Facades\DB;
use Prettus\Repository\Eloquent\BaseRepository;
use Symfony\Component\HttpFoundation\Response;

class FavouriteListRepository extends BaseRepository
{
    protected $fieldSearchable = [
        'service.title' => 'like',
        'provider.name' => 'like',
    ];

    public function model()
    {
        return FavouriteList::class;
    }

    public function index($request)
    {
        $query = $this->model->where('consumer_id', auth()->user()->id);
        switch ($request->type) {
            case FavouriteListEnum::PROVIDER:
                $query->whereNotNull('provider_id');
                break;
            case FavouriteListEnum::SERVICE:
                $query->whereNotNull('service_id');
                break;
        }

        if ($request->has('search')) {
            $searchTerm = $request->search;
            $query->where(function ($q) use ($searchTerm) {
                $q->whereHas('provider', function ($providerQuery) use ($searchTerm) {
                    $providerQuery->where('name', 'like', "%$searchTerm%");
                });

                $q->orWhereHas('service', function ($serviceQuery) use ($searchTerm) {
                    $serviceQuery->where('title', 'like', "%$searchTerm%");
                });
            });
        }

        return $query->get()->toArray();
    }

    public function store($request)
    {
        DB::beginTransaction();
        try {
            $consumerId = Helpers::getCurrentUserId();
            switch ($request->type) {
                case FavouriteListEnum::PROVIDER:
                    if (FavouriteList::isFavourite(null, $request->providerId, $consumerId)) {
                        return response()->json([
                            'message' => 'Provider is already in your Favourite List',
                            'success' => false,
                        ], 400);
                    }
                    $favouritelist = $this->model->create([
                        'provider_id' => $request->providerId,
                    ]);
                    break;
                case FavouriteListEnum::SERVICE:
                    if (FavouriteList::isFavourite($request->serviceId, null, $consumerId)) {
                        return response()->json([
                            'message' => 'Service is already in your Favourite List',
                            'success' => false,
                        ], 400);
                    }
                    $favouritelist = $this->model->create([
                        'service_id' => $request->serviceId,
                    ]);
                    break;
            }
            $data = $this->model->where('id', $favouritelist->id)->get();

            DB::commit();

            return response()->json([
                'data' => $data,
                'message' => 'Successfully added to your Favourite List',
                'success' => true,
            ]);
        } catch (Exception $e) {

            DB::rollback();
            throw new ExceptionHandler($e->getMessage(), $e->getCode());
        }
    }

    public function destroy($id)
    {
        try {
            $favouriteList = $this->model->findOrFail($id);
            if (!$favouriteList) {
                throw new ExceptionHandler(__('static.favorite_list.id_not_valid'), Response::HTTP_BAD_REQUEST);
            }
            $favouriteList->destroy($id);

            return response()->json([
                'message' => __('static.favorite_list.destroy'),
                'success' => true,
            ]);
        } catch (Exception $e) {

            throw new ExceptionHandler($e->getMessage(), $e->getCode());
        }
    }
}
