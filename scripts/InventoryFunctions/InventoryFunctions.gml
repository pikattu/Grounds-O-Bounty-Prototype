
/// ADD ONE ITEM
function InvAdd(InvArray, Item)
{
    // Check if item already exists
    for (var i = 0; i < array_length(InvArray); i++)
    {
        if (InvArray[i] != -1)
        {
            if (InvArray[i][0] == Item)
            {
                InvArray[i][1]++;
                return i;
            }
        }
    }

    // Find an empty slot
    for (var i = 0; i < array_length(InvArray); i++)
    {
        if (InvArray[i] == -1)
        {
            InvArray[i] = [Item, 1];
            return i;
        }
    }

    // Inventory is full
    return -1;
}


// ADD MULTIPLE ITEMS
function InventoryAdd(InvArray, Item, Quantity)
{
    var slot_index = -1;

    repeat (Quantity)
    {
        slot_index = InvAdd(InvArray, Item);

        if (slot_index == -1)
            return -1;
    }

    return slot_index;
}


// REMOVE ONE ITEM
function ItemRemove(InvArray, Item)
{
    for (var i = 0; i < array_length(InvArray); i++)
    {
        if (InvArray[i] != -1)
        {
            if (InvArray[i][0] == Item)
            {
                InvArray[i][1]--;

                if (InvArray[i][1] <= 0)
                {
                    InvArray[i] = -1;
                }

                return true;
            }
        }
    }

    return false;
}


// REMOVE MULTIPLE ITEMS
function ItemRemoveQuantity(InvArray, Item, Quantity)
{
    for (var i = 0; i < Quantity; i++)
    {
        if (!ItemRemove(InvArray, Item))
            return false;
    }

    return true;
}
