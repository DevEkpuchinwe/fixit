@extends('backend.layouts.master')

@section('title', __('static.additional_service.additional_services'))

@section('content')
    <div class="card">
        <div class="card-header flex-align-center">
            <h5>{{ __('static.additional_service.additional_services') }}</h5>
            <div class="btn-action">
                @can('backend.service.create')
                    <div class="btn-popup ms-auto mb-0">
                        <a href="{{ route('backend.additional-service.create') }}" class="btn">{{ __('static.additional_service.create') }}</a>
                    </div>
                @endcan
                @can('backend.service.destroy')
                    <a href="javascript:void(0);" class="btn btn-sm btn-secondary deleteConfirmationBtn" style="display: none;" data-url="{{ route('backend.delete.services') }}">
                        <span id="count-selected-rows">0</span> {{__('static.delete_selected')}}
                    </a>
                @endcan
            </div>
        </div>
        <div class="card-body common-table">
            <div class="service-table">
                <div class="table-responsive">
                    {!! $dataTable->table() !!}
                </div>
            </div>
        </div>
    </div>
@endsection

@push('js')
    {!! $dataTable->scripts() !!}
@endpush
