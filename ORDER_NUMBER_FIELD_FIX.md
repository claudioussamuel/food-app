# Order Number Field Fix

## Issue
**Error:** `Bad state: field "orderNumber" does not exist within the minified:iz`

This error occurred when trying to load orders from Firestore that were created before the `orderNumber` field was added to the OrderModel.

## Root Cause
The `OrderModel.fromJson()` and `OrderModel.fromRawData()` methods were directly accessing `data['orderNumber']` without checking if the field exists in the Firestore document. This caused errors when loading legacy orders that don't have this field.

## Solution
Added null safety checks for the `orderNumber` field in both factory methods to handle legacy orders gracefully.

### Changes Made

#### File: `lib/features/home_action_menu/model/order.dart`

**1. OrderModel.fromJson() method (line 44-46):**

**Before:**
```dart
dispatcherEmail: docData?.containsKey('dispatcherEmail') == true
    ? data['dispatcherEmail']
    : null,
orderNumber: data['orderNumber'],
```

**After:**
```dart
dispatcherEmail: docData?.containsKey('dispatcherEmail') == true
    ? data['dispatcherEmail']
    : null,
orderNumber: docData?.containsKey('orderNumber') == true
    ? data['orderNumber']
    : null,
```

**2. OrderModel.fromRawData() method (line 117-119):**

**Before:**
```dart
dispatcherEmail: data.containsKey('dispatcherEmail')
    ? data['dispatcherEmail']
    : null,
orderNumber: data['orderNumber'],
```

**After:**
```dart
dispatcherEmail: data.containsKey('dispatcherEmail')
    ? data['dispatcherEmail']
    : null,
orderNumber: data.containsKey('orderNumber')
    ? data['orderNumber']
    : null,
```

## How It Works

### Backward Compatibility
- **Legacy Orders (without orderNumber):** Will have `orderNumber = null`
- **New Orders (with orderNumber):** Will have the formatted order number (e.g., "A-001", "M-183")
- **Fallback Display:** The `formattedOrderNumber` getter automatically generates a fallback order number from the document ID if `orderNumber` is null

### Example Behavior

```dart
// Legacy order without orderNumber field
{
  "id": "abc123def456",
  "customerEmail": "user@example.com",
  // orderNumber field doesn't exist
}
// Result: orderNumber = null
// Display: formattedOrderNumber = "A-456" (generated from ID)

// New order with orderNumber field
{
  "id": "xyz789ghi012",
  "customerEmail": "user@example.com",
  "orderNumber": "M-042"
}
// Result: orderNumber = "M-042"
// Display: formattedOrderNumber = "M-042"
```

## Benefits

1. **No Data Migration Required:** Existing orders continue to work without database updates
2. **Graceful Degradation:** Legacy orders automatically get generated order numbers
3. **Future-Proof:** All new orders will have proper formatted order numbers
4. **Consistent Display:** Users see order numbers regardless of when the order was created

## Testing

To verify the fix works:

1. **Test with legacy orders:** Orders created before orderNumber field should load without errors
2. **Test with new orders:** Orders created after the fix should have proper orderNumber values
3. **Test order display:** Both legacy and new orders should display order numbers correctly
4. **Test order tracking:** Order status screens should show order numbers for all orders

## Related Files

- `lib/features/home_action_menu/model/order.dart` - OrderModel with null safety
- `lib/data/services/order_number_service.dart` - Service that generates order numbers
- `lib/features/order/screens/order_status/order_status_screen.dart` - Displays order numbers
- `lib/features/order/screens/order_detail/order_detail_modal.dart` - Shows order details

## Result
✅ Orders load successfully regardless of whether they have the orderNumber field
✅ No more "field does not exist" errors
✅ Backward compatible with all existing orders in the database
