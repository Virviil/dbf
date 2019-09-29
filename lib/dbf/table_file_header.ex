defmodule Dbf.TableFileHeader do
  defstruct [
    :version_number,
    :dbase_iv_win_memo_presense,
    :dbase_sql_presense,
    :dbase_any_memo_presense,
    :last_update,
    :records_number,
    :bytes_in_header_number,
    :bytes_in_record_number,
    :incomplete_dbase_iv_transaction?,
    :dbase_iv_encryption?,
    :production_mdx?,
    :language_driver_id,
    :language_driver_name
  ]

  def read_table_file_header(device) do
    case IO.binread(device, 68) do
      <<
        dbase_any_memo_presense::size(1),
        dbase_sql_presense::size(3),
        dbase_iv_win_memo_presense::size(1),
        version_number::size(3), # 67 +
        last_update_year::integer, # 66 +
        last_update_month::integer, # 65
        last_update_date::integer, # 64
        records_number::little-integer-32, # 60
        bytes_in_header_number::little-integer-16, # 58
        bytes_in_record_number::little-integer-16, # 56
        _reserved_filled_with_zeroes::binary-2, # 54
        incomplete_dbase_iv_transaction_flag::integer, # 53
        dbase_iv_encryption_flag::integer, # 52
        _reserved_for_multi_user::binary-12, # 44
        production_mdx_flag::integer,
        language_driver_id::integer,
        _reserverd_filled_with_zeroes::binary-2,
        language_driver_name::binary-32,
        _reserved::binary-4
      >> ->
        %__MODULE__{
          version_number: version_number,
          dbase_iv_win_memo_presense: dbase_iv_win_memo_presense,
          dbase_sql_presense: dbase_sql_presense,
          dbase_any_memo_presense: dbase_any_memo_presense,
          last_update:
            set_last_update_date(last_update_year, last_update_month, last_update_date),
          records_number: records_number,
          bytes_in_header_number: bytes_in_header_number,
          bytes_in_record_number: bytes_in_record_number,
          incomplete_dbase_iv_transaction?: incomplete_dbase_iv_transaction_flag,
          dbase_iv_encryption?: dbase_iv_encryption_flag,
          production_mdx?: production_mdx_flag,
          language_driver_id: language_driver_id,
          language_driver_name: language_driver_name
        }

      _ ->
        :error
    end
  end

  defp set_last_update_date(raw_year, raw_month, raw_day) do
    Date.new(1900 + raw_year, raw_month, raw_day)
  end
end
