import React from "react";
import {
  CBadge,
  CCard,
  CCardBody,
  CCardHeader,
  CCol,
  CDataTable,
  CRow,
  CButton,
  CForm,
  CFormGroup,
  CLabel,
  CInput,
  CSelect,
  CInputFile,
  CModalFooter,
} from "@coreui/react";

import { render } from "enzyme/build";

const fields = ["Id", "Owner", "Location", "Size", "Use", "edit", "delete"];

export default function AllLands() {
  return (
    <>
      <CRow>
        <CCol>
          <CCard>
            <CCardHeader>All Lands Details</CCardHeader>
            <CCardBody>
              <CDataTable
                fields={fields}
                hover
                striped
                bordered
                size="sm"
                itemsPerPage={10}
                pagination
                scopedSlots={{
                  edit: (item, index) => {
                    return (
                      <td>
                        <CButton
                          color="primary"
                          variant="outline"
                          shape="square"
                          size="sm"
                        >
                          Edit
                        </CButton>
                      </td>
                    );
                  },
                  delete: (item, index) => {
                    return (
                      <td>
                        <CButton
                          color="danger"
                          variant="outline"
                          shape="square"
                          size="sm"
                        >
                          Delete
                        </CButton>
                      </td>
                    );
                  },
                }}
              />
            </CCardBody>
          </CCard>
        </CCol>
      </CRow>
    </>
  );
}
