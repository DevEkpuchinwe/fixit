@extends('backend.layouts.master')
@section('title', __('static.booking.details'))
@push('style')
    <link rel="stylesheet" type="text/css" href="{{ asset('admin/css/vendors/flatpickr.min.css') }}">
@endpush
@section('content')
    @use('App\Enums\PaymentStatus')
    @use('app\Helpers\Helpers')
    @use('App\Enums\BookingEnum')
    @use('App\Models\BookingStatus')
    @php
        $statuses = BookingStatus::whereNull('deleted_at')->where('status', true)->get();
        $paymentStatuses = PaymentStatus::ALL;
    @endphp
    <div class="tab2-card booking-details-tabs">
        <ul class="nav nav-tabs" id="bookingTab" role="tablist">
            <li class="nav-item">
                <a class="nav-link active" id="v-pills-tabContent" data-bs-toggle="pill" data-bs-target="#booking_details"
                    type="button" role="tab" aria-controls="booking_details" aria-selected="true">
                    <i data-feather="settings"></i>
                    {{ __('static.booking.general') }}
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="v-pills-profile-tab" data-bs-toggle="pill" data-bs-target="#booking_status"
                    type="button" role="tab" aria-controls="v-pills-profile" aria-selected="false"><i
                        data-feather="alert-circle"></i>
                    {{ __('static.booking.status') }}
                </a>
            </li>
        </ul>
        <div class="tab-content" id="bookingTabContent">
            <div class="tab-pane fade show active" id="booking_details">
                <div class="service-main row g-sm-4 g-3">
                    <div class="col-md-6">
                        <div class="booking-detail card summary-detail">
                            <div class="card-header flex-center">
                                <div>
                                    <h5>{{ __('static.booking.details') }} #{{ $childBooking->booking_number }}</h5>
                                    <span>{{ __('static.booking.created_at') }}{{ $childBooking->created_at->format('j F Y, g:i A') }}</span>
                                </div>
                                
                                @if (
                                    !is_null($childBooking->servicemen) &&
                                        $childBooking->booking_status_id == Helpers::getbookingStatusId(BookingEnum::ACCEPTED))
                                    <button class="assign-btn btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#assignmodal"
                                    id="assign_serviceman">{{ __('static.booking.assign') }}</button>
                                @endif
                                @if ($childBooking->booking_status_id == Helpers::getbookingStatusId(BookingEnum::ASSIGNED))
                                    <button class="assign-btn btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#assignmodal"
                                        id="assign_serviceman">{{ __('static.booking.reassign') }}</button>
                                @endif
                            </div>
                            <div class="provider-details-box mt-sm-3 mt-2">
                                <ul class="list-unstyled mb-0">
                                    <li>
                                        <p>{{ __('static.service.title') }}:</p>
                                        <span>{{ $childBooking?->service?->title }}</span>
                                    </li>
                                    <li>
                                        <p>{{ __('static.service.service_price') }}:</p>
                                        <span>{{ $childBooking?->service?->service_rate }}</span>
                                    </li>
                                    <li>
                                        <p>{{ __('static.service.service_type') }}:</p>
                                        <span>{{ $childBooking->service?->type }}</span>
                                    </li>
                                    <li>
                                        <p>{{ __('static.booking.payment_method') }}:</p>
                                        <span>{{ $childBooking->payment_method }}</span>
                                    </li>
                                    <li>
                                        <p>{{ __('static.booking.payment_status') }}:</p>
                                        <span>{{ $childBooking?->payment_status }}</span>
                                    </li>
                                    <li>
                                        <p>{{ __('static.service.required_servicemen') }}:</p>
                                        <span>{{ $childBooking?->service?->required_servicemen ?? 'N/A' }}</span>
                                    </li>
                                    @if ($childBooking?->total_extra_servicemen > 0)    
                                        <li>
                                            <p>{{ __('static.service.total_extra_servicemen') }}:</p>
                                            <span>{{ $childBooking->total_extra_servicemen ?? 0 }}</span>
                                        </li>
                                    @endif
                                    @if (isset($childBooking->per_serviceman_charge))
                                        <li>
                                            <p>{{ __('static.service.per_serviceman_charge') }}</p>
                                            <span>{{ Helpers::getSettings()['general']['default_currency']->symbol }}{{ $childBooking->per_serviceman_charge ?? 0}}</span>
                                        </li>
                                    @endif
                                    @if (isset($childBooking->total_extra_servicemen_charge))
                                        <li>
                                            <p>{{ __('static.service.total_servicemen_charge') }}</p>
                                            <span>{{ Helpers::getSettings()['general']['default_currency']->symbol }}{{ $childBooking->total_extra_servicemen_charge ?? 0 }}</span>
                                        </li>
                                    @endif
                                    @if (isset($childBooking?->address))
                                        <li>
                                            <p>{{ __('static.service.booking_address') }}</p>
                                            <span>{{ $childBooking->address->address }},{{ $childBooking?->address->country?->name }}, {{ $childBooking?->address?->state?->name }}, {{ $childBooking?->address?->city }}, {{ $childBooking?->address?->postal_code }}</span>
                                        </li>
                                    @endif
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="row g-4">
                            <div class="col-12">
                                <div class="booking-detail-2 card border-0">
                                    <div class="card-header">
                                        <h4 class="mb-0">{{ __('static.consumer_details') }}</h4>
                                    </div>
                                    <div class="booking-details-box">
                                        <div class="left-box">
                                            <div class="img-box">
                                                @php
                                                    $media = $childBooking?->consumer?->getFirstMedia('image');
                                                    $imageUrl = $media ? $media->getUrl() : null;
                                                @endphp
                                                @if ($imageUrl)
                                                    <img src="{{ $imageUrl }}" class="img-fluid" alt="{{ $childBooking?->consumer?->name ?? 'User Image' }}">
                                                @else 
                                                    <div class="initial-letter">
                                                        <span>{{ strtoupper($childBooking?->consumer?->name[0]) }}</span>
                                                    </div>
                                                @endif
                                            </div>
                                            <div class="details-box">
                                                <a href="{{ route('backend.consumer.general-info', ['id'=> $childBooking->consumer->id]) }}" target="_blank">{{ $childBooking->consumer->name }}</a>
                                                <h4 class="name">{{ $childBooking->consumer->email }}</h4>
                                                @if ($childBooking?->consumer?->review_ratings > 0)    
                                                    <div class="rate mt-2">
                                                        @for ($i = 0; $i < $childBooking?->consumer?->review_ratings; ++$i)
                                                            <img src="{{ asset('admin/images/svg/star.svg') }}" alt="star"  class="img-fluid star">
                                                        @endfor
                                                        <small>({{ $childBooking->consumer?->review_ratings }})</small>
                                                    </div>
                                                @endif     
                                            </div>
                                        </div>
                                        <div class="right-box">
                                            <ul class="list-unstyled mb-0">
                                                <li>
                                                    <p><span>{{ __('static.phone') }}:</span>+{{ $childBooking->consumer->code . ' ' . $childBooking->consumer->phone }}</p>
                                                </li>
                                                <li>
                                                    <p><span>{{ __('static.country') }}:</span>{{ $childBooking?->consumer?->getPrimaryAddressAttribute()?->country?->name }}</p>
                                                </li>
                                                <li>
                                                    <p><span>{{ __('static.state') }}:</span>{{ $childBooking?->consumer?->getPrimaryAddressAttribute()?->state?->name }}</p>
                                                </li>
                                                <li>
                                                    <p><span>{{ __('static.city') }}:</span>{{ $childBooking?->consumer?->getPrimaryAddressAttribute()?->city }}</p>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>  
                            </div>

                            <div class="col-12">
                                <div class="booking-detail-2 card border-0">
                                    <div class="card-header">
                                        <h4 class="mb-0">{{ __('static.provider_details') }}</h4>
                                    </div>
                                    <div class="booking-details-box">
                                        <div class="left-box">
                                            <div class="img-box">
                                                @php
                                                    $media = $childBooking?->provider?->getFirstMedia('image');
                                                    $imageUrl = $media ? $media->getUrl() : null;
                                                @endphp
                                                @if ($imageUrl)
                                                    <img src="{{ $imageUrl }}" class="img-fluid" alt="{{ $childBooking?->provider?->name ?? 'User Image' }}">
                                                @else 
                                                    <div class="initial-letter">
                                                        <span>{{ strtoupper($childBooking?->provider?->name[0]) }}</span>
                                                    </div>
                                                @endif
                                            </div>
                                            <div class="details-box">
                                                <a href="{{ route('backend.provider.general-info', ['id'=> $childBooking->provider->id]) }}">{{ $childBooking->provider?->name }}</a>
                                                <h4 class="name">{{ $childBooking->provider?->email }}</h4>
                                                @if ($childBooking->provider?->review_ratings > 0)    
                                                    <div class="rate mt-2">
                                                        @for ($i = 0; $i < $childBooking?->rating; ++$i)
                                                            <img src="{{ asset('admin/images/svg/star.svg') }}" alt="star"  class="img-fluid star">
                                                        @endfor
                                                        <small>({{ $childBooking->provider?->review_ratings }})</small>
                                                    </div>
                                                @endif  
                                            </div>
                                        </div>
                                        <div class="right-box">
                                            <ul class="list-unstyled mb-0">
                                                @if (isset($childBooking->provider?->code) && isset($childBooking->provider->phone))
                                                    <li>
                                                        <p><span>{{ __('static.phone') }}:</span> +{{ $childBooking->provider?->code . ' ' . $childBooking->provider->phone }}</p>
                                                    </li>
                                                @endif
                                                @if (isset($childBooking?->provider?->getPrimaryAddressAttribute()?->country?->name))
                                                    <li>
                                                        <p><span>{{ __('static.country') }}:</span> {{ $childBooking->provider->getPrimaryAddressAttribute()->country->name }}</p>
                                                    </li>
                                                @endif
                                                @if (isset($childBooking?->provider?->getPrimaryAddressAttribute()?->state?->name))
                                                    <li>
                                                        <p><span>{{ __('static.state') }}:</span> {{ $childBooking->provider->getPrimaryAddressAttribute()->state->name }}</p>
                                                    </li>
                                                @endif
                                                @if (isset($childBooking?->provider?->getPrimaryAddressAttribute()?->city))
                                                    <li>
                                                        <p><span>{{ __('static.city') }}:</span> {{ $childBooking->provider->getPrimaryAddressAttribute()->city }}</p>
                                                    </li>
                                                @endif
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="booking-detail-2 card border-0">
                            <div class="card-header">
                                <h4>{{ __('static.summary') }}</h4>
                                <div class="btn-popup ms-auto mb-0">
                                    <a href="{{ route('invoice', $childBooking->booking_number) }}"
                                        class="btn link-btn">{{ __('static.booking.invoice') }}</a>
                                </div>
                            </div>
                            <div class="provider-details-box">
                                <ul class="list-unstyled mb-0">
                                    <li>
                                        <p><span>{{ __('static.booking.payment_method') }}:</span>{{ $childBooking->payment_method }}
                                        </p>
                                    </li>
                                    <li>
                                        <p><span>{{ __('static.booking.payment_status') }}:</span>{{ $childBooking->payment_status }}
                                        </p>
                                    </li>
                                    <li>
                                        <p><span>{{ __('static.booking.coupon_discount') }}:</span>{{ Helpers::getSettings()['general']['default_currency']->symbol }}{{ $childBooking->coupon_total_discount }}
                                        </p>
                                    </li>
                                    <li>
                                        <p><span>{{ __('static.booking.service_discount') }}:</span>{{ Helpers::getSettings()['general']['default_currency']->symbol }}{{ $childBooking->discount ?? 0 }}
                                        </p>
                                    </li>
                                    <li>
                                        <p><span>{{ __('static.booking.service_tax') }}:</span>{{ Helpers::getSettings()['general']['default_currency']->symbol }}{{ $childBooking->tax ?? 0 }}
                                        </p>
                                    </li>
                                    <li>
                                        <p><span>{{ __('static.booking.service_amount') }}:</span>{{ Helpers::getSettings()['general']['default_currency']->symbol }}{{ $childBooking->service_price ?? 0 }}
                                        </p>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="service-right-box">
                            <div class="service-title">
                                <h4 class="mb-0">{{ __('static.booking.booking_settings') }}</h4>
                            </div>
                            <div class="row g-sm-4 g-3">
                                <div class="col-12">
                                    <div class="form-group">
                                        <label>{{ __('static.booking.booking_status') }}</label>
                                        <form action="{{ route('backend.bookingStatus.update', ['booking_id' => $childBooking->id]) }}"
                                            method="post">
                                            @php
                                                $bookingStatus = $childBooking->booking_status->slug;
                                            @endphp
                                            @csrf
                                            <select class="select-2 form-control" id="bookingStatusFilter" name="booking_status"
                                                data-placeholder="{{ __('static.booking.select_booking_status') }}"
                                                onchange="this.form.submit()">
                                                <option class="select-placeholder" value=""></option>
                                                @foreach ($statuses as $status)
                                                    <option value="{{ $status?->slug }}"
                                                        @if ($bookingStatus == $status?->slug) selected @endif>{{ $status?->name }}
                                                    </option>
                                                @endforeach
                                            </select>
                                        </form>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="form-group">
                                        <div class="col-12">
                                            <label for="">Select Date</label>
                                        </div>
                                        <div class="col-12">
                                            <div class="booking-date-detail d-flex gap-2">
                                                <input class="form-control" type="text" id="booking-date"
                                                    placeholder="{{ __('static.service_package.select_date') }}">
                                                <button id="confirmDateBtn" class="btn btn-primary"
                                                    style="display: none;">{{ __('Confirm') }}</button>
                                                <form id="updateBookingForm" action="{{ route('backend.booking.updateDateTime') }}"
                                                    method="POST">
                                                    @csrf
                                                    <input type="hidden" name="booking_id" value="{{ $childBooking->id }}">
                                                    <input type="hidden" name="date_time" id="selected-date">
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="form-group row">
                                        <label for="">Payment Status</label>
                                        <div class="payment-status d-flex gap-2">
                                            <select class="select-2 form-control" name="payment_status" id="paymentStatus"
                                                data-placeholder="{{ __('static.booking.select_booking_payment_status') }}">
                                                @foreach ($paymentStatuses as $paymentStatus)
                                                    <option value="{{ $paymentStatus }}"
                                                        @if ($childBooking->payment_status === strtoupper($paymentStatus)) selected @endif>{{ $paymentStatus }}
                                                    </option>
                                                @endforeach
                                            </select>
                                            <button id="confirmPaymentBtn" class="btn btn-primary" style="display: none;">
                                                {{ __('Confirm') }}</button>
                                            <form id="updatePaymentForm" action="{{ route('backend.booking.updatePaymentStatus') }}"
                                                method="POST">
                                                @csrf
                                                <input type="hidden" name="booking_id" value="{{ $childBooking->id }}">
                                                <input type="hidden" name="payment_status" id="payment-status-field">
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="tab-pane fade" id="booking_status">
                <div class="row booking-status g-4">
                    <div class="col-xxl-4 col-xl-5">
                        <div class="booking-log card">
                            <div class="card-header d-flex align-items-center gap-2 justify-content-between px-0 pt-0">
                                <div>
                                    <h5>{{ __('static.booking.details') }} #{{ $childBooking->booking_number }}</h5>
                                    <span>{{ __('static.booking.created_at') }}{{ $childBooking->created_at->format('j F Y, g:i A') }}</span>
                                </div>
                            </div>
                            <div class="card-body px-2 status-body custom-scroll">
                                <ul>
                                    @forelse ($childBooking->booking_status_logs as $status)
                                        <li class="d-flex">
                                            <div class="activity-dot activity-dot-{{ $status->status->hexa_code }}">
                                                {{ $status->status->hexa_code }}
                                            </div>
                                            <div class="w-100 ms-3">
                                                <p class="d-flex justify-content-between mb-1"><span
                                                        class="date-content">{{ $status->created_at->format('d-m-Y') }}</span><span>{{ $status->created_at->format('g:i A') }}</span>
                                                </p>
                                                <h6>{{ $status->status->name }}<span class="dot-notification"></span>
                                                </h6>
                                                <p class="f-light">{{ $status->description }}</p>
                                            </div>
                                        </li>
                                    @empty
                                        <li class="d-flex">
                                            <div id="activity-dot-not-found" class="activity-dot activity-dot-primary">
                                            </div>
                                            <div class="w-100 ms-3">
                                                <h4 class="no-status">{{ __('static.no_status_log_found') }}</h4>
                                            </div>
                                        </li>
                                    @endforelse
                                </ul>
                            </div>
                        </div>
                    </div>
                    @if ($childBooking->servicemen->count() > 0)
                        <div class="col-xxl-8 col-xl-7">
                            <div class="card">
                                <div class="card-header flex-align-center">
                                    <h5>{{ __('static.servicemen_information') }}</h5>
                                </div>
                                <div class="card-body common-table">
                                    <div class="serviceman-info-table">
                                        <div class="table-responsive">
                                            <table class="table table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>{{ __('static.name') }}</th>
                                                        <th>{{ __('static.email') }}</th>
                                                        <th>{{ __('static.phone') }}</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    @foreach ($childBooking->servicemen as $serviceman)
                                                        <tr>
                                                            <td>{{ $serviceman->name }}</td>
                                                            <td>{{ $serviceman->email }}</td>
                                                            <td>+{{ $serviceman->code . ' ' . $serviceman->phone }}
                                                            </td>
                                                        </tr>
                                                    @endforeach
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    @endif
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="assignmodal" tabindex="-1" aria-labelledby="confirmationModalLabel"
        aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content service-man">
                <div class="modal-header">
                    <h5>{{ __('static.assign_service') }}</h5>
                </div>
                <form id="assignServicemanForm" action="{{ route('backend.booking.assignServicemen') }}"
                    method="POST">
                    @csrf
                    <div class="modal-body text-start">
                        <div class="service-man-detail">
                            <div class="form-group row">
                                <label class="col-md-2" for="servicemen">{{ __('static.booking.serviceman') }}</label>
                                <div class="col-md-10 error-div select-dropdown">
                                    <select class="select-2 form-control" id="servicemen" search="true"
                                        name="servicemen[]"
                                        data-placeholder="{{ __('static.booking.select_serviceman') }}" multiple>

                                    </select>
                                    @error('servicemen')
                                        <span class="invalid-feedback d-block" role="alert">
                                            <strong>{{ $message }}</strong>
                                        </span>
                                    @enderror
                                    <input type="hidden" name="booking_id" value="{{ $childBooking->id }}">
                                    @if ($childBooking->booking_status_id == Helpers::getbookingStatusId(BookingEnum::ASSIGNED))
                                        <input type="hidden" name="reassign">
                                    @endif
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="assign-btn btn">{{ __('static.save') }}</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
@endsection

@push('js')
    <script src="{{ asset('admin/js/flatpickr.js') }}"></script>
    <script>
        (function($) {
            "use strict";
            $(document).ready(function() {
                $('#servicemen').select2();
                var reqservicemen = "{{ isset($childBooking->total_servicemen) ? $childBooking->total_servicemen : 1 }}"
                var confirmBtn = $('#confirmPaymentBtn');
                $('#servicemen').select2({
                    placeholder: 'Select a serviceman',
                    allowClear: true,
                    minimumSelectionLength: reqservicemen,
                });

                var flatpickrInstance = flatpickr("#booking-date", {
                    altInput: true,
                    altFormat: "F j, Y H:i",
                    enableTime: true,
                    dateFormat: "Y-m-d H:i",
                    defaultDate: "{{ \Carbon\Carbon::parse($childBooking->date_time)->format('Y-m-d H:i') }}",
                    onChange: function(selectedDates, dateStr) {
                        if (dateStr) {
                            $("#confirmDateBtn").show();
                            $("#selected-date").val(dateStr);
                        }
                    }
                });

                $("#confirmDateBtn").click(function() {
                    $("#updateBookingForm").submit();
                });

                $('#paymentStatus').on('change', function() {
                    var paymentStatus = $(this).val();
                    var updateForm = $('#updatePaymentForm');

                    // Update hidden field with new payment status
                    $('#payment-status-field').val(paymentStatus);

                    // Disable form validation before modifying the select2
                    updateForm.validate().resetForm();

                    // Show the confirm button after validation
                    confirmBtn.show();

                    // Manually validate the form after modification
                    if (updateForm.valid()) {
                        confirmBtn.prop('disabled', false); // Enable confirm button if valid
                    } else {
                        confirmBtn.prop('disabled', true); // Disable confirm button if invalid
                    }
                });

                // Confirm button click event
                confirmBtn.on('click', function() {
                    var form = $('#updatePaymentForm');
                    form.submit(); // Submit the form
                });

                // Click event handler for assign_serviceman button
                $("#assign_serviceman").click(function() {
                    var booking_id = "{{ $childBooking->id }}";
                    $.ajax({
                        url: "{{ route('backend.booking.getServicemen') }}",
                        type: "GET",
                        data: {
                            booking_id: booking_id,
                            _token: '{{ csrf_token() }}'
                        },
                        dataType: "json",
                        success: function(data) {
                            $("#servicemen").empty();
                            $.each(data, function(index, serviceman) {
                                $("#servicemen").append(
                                    $("<option></option>").val(serviceman.id)
                                    .text(serviceman.name)
                                );
                            });
                            $('#servicemen').trigger('change');
                        },
                        error: function(xhr, status, error) {
                            console.error("Error fetching servicemen: ", error);
                        }
                    });

                });
                // Loop to remove '#' from class names
                var elements = document.getElementsByClassName('activity-dot');
                for (var i = 0; i < elements.length; i++) {
                    var element = elements[i];
                    var className = element.className;
                    className = className.replace('#', '');
                    element.className = className;
                }
            });
        })(jQuery);
    </script>
@endpush
