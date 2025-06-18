@extends('backend.layouts.master')

@section('title', __('static.plan.subscriptions'))

@section('content')
    <div class="card">
        <div class="card-header flex-align-center">
            <h5>{{ __('static.plan.subscriptions') }}</h5>
        </div>
        <div class="card-body common-table">
            <div class="subscription-table">
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
