/*
 * Copyright (C) 2017 Katarina Sheremet
 * This file is part of Delern.
 *
 * Delern is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * Delern is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with  Delern.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.dasfoo.delern.adapters;

import android.content.Context;
import android.support.annotation.Nullable;

import com.firebase.ui.database.FirebaseRecyclerAdapter;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.Query;

import org.dasfoo.delern.handlers.OnDeckViewHolderClick;
import org.dasfoo.delern.models.listeners.AbstractDataAvailableListener;
import org.dasfoo.delern.models.Deck;
import org.dasfoo.delern.models.User;
import org.dasfoo.delern.viewholders.DeckViewHolder;

/**
 * Created by katarina on 11/19/16.
 */

public class DeckRecyclerViewAdapter extends FirebaseRecyclerAdapter<Deck, DeckViewHolder> {

    private static final int CARDS_COUNTER_LIMIT = 200;
    private OnDeckViewHolderClick mOnDeckViewHolderClick;
    private Context mContext;
    private final User mUser;

    /**
     * @param modelClass      Firebase will marshall the data at a location into an instance
     *                        of a class that you provide
     * @param modelLayout     This is the layout used to represent a single item in the list.
     *                        You will be responsible for populating an instance of the
     *                        corresponding view with the data from an instance of modelClass.
     * @param viewHolderClass The class that hold references to all sub-views in an instance
     *                        modelLayout.
     * @param ref             The Firebase location to watch for data changes. Can also be a slice
     *                        of a location, using some.
     * @param user            Current user.
     */
    public DeckRecyclerViewAdapter(final Class<Deck> modelClass, final int modelLayout,
                                   final Class<DeckViewHolder> viewHolderClass, final Query ref,
                                   final User user) {
        super(modelClass, modelLayout, viewHolderClass, ref);
        mUser = user;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    protected void populateViewHolder(final DeckViewHolder viewHolder, final Deck deck,
                                      final int position) {
        viewHolder.getDeckTextView().setText(deck.getName());
        viewHolder.setDeckCardType(deck.getDeckType());
        viewHolder.setOnViewClick(mOnDeckViewHolderClick);
        viewHolder.setContext(mContext);
        AbstractDataAvailableListener<Long> onCardsCountDataAvailableListener =
                new AbstractDataAvailableListener<Long>(mContext) {
            @Override
            public void onData(@Nullable final Long cardsCount) {
                if (cardsCount <= CARDS_COUNTER_LIMIT) {
                    viewHolder.getCountToLearnTextView().setText(String.valueOf(cardsCount));
                } else {
                    String tooManyCards = CARDS_COUNTER_LIMIT + "+";
                    viewHolder.getCountToLearnTextView().setText(tooManyCards);
                }
            }
        };

        Deck.fetchCount(
                getItem(position).fetchCardsToRepeatWithLimitQuery(CARDS_COUNTER_LIMIT + 1),
                onCardsCountDataAvailableListener);
    }

    @Override
    protected Deck parseSnapshot(final DataSnapshot snapshot) {
        return Deck.fromSnapshot(snapshot, Deck.class, mUser);
    }

    /**
     * Set deck view holder click handler.
     *
     * @param onDeckViewHolderClick deck view holder click handler
     */
    public void setOnDeckViewHolderClick(final OnDeckViewHolderClick onDeckViewHolderClick) {
        this.mOnDeckViewHolderClick = onDeckViewHolderClick;
    }

    /**
     * Set context for the view holder.
     *
     * @param context context
     */
    public void setContext(final Context context) {
        this.mContext = context;
    }
}
