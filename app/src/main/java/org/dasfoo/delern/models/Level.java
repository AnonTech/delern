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

package org.dasfoo.delern.models;

/**
 * Created by katarina on 11/1/16.
 */

public enum Level {

    /**
     * Level of card. Card is new.
     */
    L0,

    /**
     * Level of card for repetition intervals.
     */
    L1,

    /**
     * Level of card for repetition intervals.
     */
    L2,

    /**
     * Level of card for repetition intervals.
     */
    L3,

    /**
     * Level of card for repetition intervals.
     */
    L4,

    /**
     * Level of card for repetition intervals.
     */
    L5,

    /**
     * Level of card for repetition intervals.
     */
    L6,

    /**
     * Level of card for repetition intervals.
     */
    L7;

    private static Level[] sValues = values();

    /**
     * Returns next level by current in enum. If current level is L3, it returns L4.
     *
     * @return next level of card.
     */
    private Level next() {
        return sValues[(this.ordinal() + 1) % sValues.length];
    }

    /**
     * Specifies next level in repetition intervals using current.
     *
     * @param currentLevel current level.
     * @return next level.
     */
    public static String getNextLevel(final String currentLevel) {
        Level cLevel = Level.valueOf(currentLevel);
        if (cLevel == Level.L7) {
            return Level.L7.name();
        }
        return cLevel.next().name();
    }
}
